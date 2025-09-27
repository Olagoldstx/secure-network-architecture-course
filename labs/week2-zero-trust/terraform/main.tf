terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# -----------------------------
# Transit Gateway (hub)
# -----------------------------
resource "aws_ec2_transit_gateway" "tgw" {
  description                     = "zero-trust-hub"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"
}

# Route tables
resource "aws_ec2_transit_gateway_route_table" "rt_app"        { transit_gateway_id = aws_ec2_transit_gateway.tgw.id }
resource "aws_ec2_transit_gateway_route_table" "rt_db"         { transit_gateway_id = aws_ec2_transit_gateway.tgw.id }
resource "aws_ec2_transit_gateway_route_table" "rt_inspection" { transit_gateway_id = aws_ec2_transit_gateway.tgw.id }

# -----------------------------
# Attach VPCs
# -----------------------------
resource "aws_ec2_transit_gateway_vpc_attachment" "att_app" {
  subnet_ids              = var.app_subnet_ids
  transit_gateway_id      = aws_ec2_transit_gateway.tgw.id
  vpc_id                  = var.app_vpc_id
  appliance_mode_support  = "enable"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "att_db" {
  subnet_ids              = var.db_subnet_ids
  transit_gateway_id      = aws_ec2_transit_gateway.tgw.id
  vpc_id                  = var.db_vpc_id
  appliance_mode_support  = "enable"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "att_inspection" {
  subnet_ids              = var.inspection_subnet_ids
  transit_gateway_id      = aws_ec2_transit_gateway.tgw.id
  vpc_id                  = var.inspection_vpc_id
  appliance_mode_support  = "enable"
}

# -----------------------------
# Associations
# -----------------------------
resource "aws_ec2_transit_gateway_route_table_association" "assoc_app" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.att_app.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_app.id
}

resource "aws_ec2_transit_gateway_route_table_association" "assoc_db" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.att_db.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_db.id
}

resource "aws_ec2_transit_gateway_route_table_association" "assoc_inspection" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.att_inspection.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_inspection.id
}

# -----------------------------
# Propagation + Routes (force traffic via inspection)
# -----------------------------
resource "aws_ec2_transit_gateway_route_table_propagation" "prop_app_to_inspection" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.att_app.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_inspection.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "prop_db_to_inspection" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.att_db.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rt_inspection.id
}

# Strict east-west routes (replace with your real CIDRs)
resource "aws_ec2_transit_gateway_route" "rt_app_to_db_via_inspection" {
  destination_cidr_block          = var.db_cidr
  transit_gateway_route_table_id  = aws_ec2_transit_gateway_route_table.rt_app.id
  transit_gateway_attachment_id   = aws_ec2_transit_gateway_vpc_attachment.att_inspection.id
}

resource "aws_ec2_transit_gateway_route" "rt_db_to_app_via_inspection" {
  destination_cidr_block          = var.app_cidr
  transit_gateway_route_table_id  = aws_ec2_transit_gateway_route_table.rt_db.id
  transit_gateway_attachment_id   = aws_ec2_transit_gateway_vpc_attachment.att_inspection.id
}

# -----------------------------
# Organizations SCPs (optional; needs org permissions)
# -----------------------------
data "aws_organizations_organization" "org" {}

resource "aws_organizations_policy" "deny_dangerous" {
  name        = "deny-iam-user-and-disable-cloudtrail"
  description = "Guardrails: no IAM users; cannot disable CloudTrail; restrict regions"
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Sid": "DenyIAMUserCreation",
        "Effect": "Deny",
        "Action": ["iam:CreateUser","iam:DeleteUser","iam:CreateAccessKey"],
        "Resource": "*"
      },
      {
        "Sid": "DenyDisableCloudTrail",
        "Effect": "Deny",
        "Action": ["cloudtrail:StopLogging","cloudtrail:DeleteTrail","cloudtrail:UpdateTrail"],
        "Resource": "*"
      },
      {
        "Sid": "RestrictRegions",
        "Effect": "Deny",
        "Action": "*",
        "Resource": "*",
        "Condition": { "StringNotEquals": { "aws:RequestedRegion": ["us-east-1","us-west-2"] } }
      }
    ]
  })
}

resource "aws_organizations_policy_attachment" "attach_root" {
  policy_id = aws_organizations_policy.deny_dangerous.id
  target_id = data.aws_organizations_organization.org.roots[0].id
}
