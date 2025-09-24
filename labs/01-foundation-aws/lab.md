
# Lab 01 — AWS Foundation (VPC → ALB → Private App → Endpoints)

> **Outcome:** A production‑style VPC with public/private subnets, NAT, ALB, SG/NACL, and endpoints. App nodes in private only.

## Prereqs
- AWS CLI configured; region set (e.g., `us-east-1`)
- An IAM admin role (temporary) with MFA

## Steps
1) **Create VPC and Subnets**
```bash
VPC_ID=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 --query Vpc.VpcId --output text)
aws ec2 create-tags --resources $VPC_ID --tags Key=Name,Value=prod-vpc

# Get AZs
AZA=$(aws ec2 describe-availability-zones --query 'AvailabilityZones[0].ZoneName' --output text)
AZB=$(aws ec2 describe-availability-zones --query 'AvailabilityZones[1].ZoneName' --output text)

PUBA=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.0.0/24 --availability-zone $AZA --query Subnet.SubnetId --output text)
PUBB=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.1.0/24 --availability-zone $AZB --query Subnet.SubnetId --output text)
PRVA=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.10.0/24 --availability-zone $AZA --query Subnet.SubnetId --output text)
PRVB=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.11.0/24 --availability-zone $AZB --query Subnet.SubnetId --output text)
```

2) **IGW, Routes, and NAT**
```bash
IGW=$(aws ec2 create-internet-gateway --query InternetGateway.InternetGatewayId --output text)
aws ec2 attach-internet-gateway --vpc-id $VPC_ID --internet-gateway-id $IGW

# Public RT
PRT=$(aws ec2 create-route-table --vpc-id $VPC_ID --query RouteTable.RouteTableId --output text)
aws ec2 associate-route-table --route-table-id $PRT --subnet-id $PUBA
aws ec2 associate-route-table --route-table-id $PRT --subnet-id $PUBB
aws ec2 create-route --route-table-id $PRT --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW

# NAT in each AZ (cost: ~$32/mo ea; for lab you can do one)
EIPA=$(aws ec2 allocate-address --domain vpc --query AllocationId --output text)
NAT1=$(aws ec2 create-nat-gateway --subnet-id $PUBA --allocation-id $EIPA --query NatGateway.NatGatewayId --output text)

# Private RT
PVT=$(aws ec2 create-route-table --vpc-id $VPC_ID --query RouteTable.RouteTableId --output text)
aws ec2 associate-route-table --route-table-id $PVT --subnet-id $PRVA
aws ec2 associate-route-table --route-table-id $PVT --subnet-id $PRVB
aws ec2 create-route --route-table-id $PVT --destination-cidr-block 0.0.0.0/0 --nat-gateway-id $NAT1
```

3) **Security Groups & ALB**
```bash
# SGs
ALB_SG=$(aws ec2 create-security-group --group-name alb-sg --description "ALB SG" --vpc-id $VPC_ID --query GroupId --output text)
APP_SG=$(aws ec2 create-security-group --group-name app-sg --description "App SG" --vpc-id $VPC_ID --query GroupId --output text)

aws ec2 authorize-security-group-ingress --group-id $ALB_SG --protocol tcp --port 443 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $APP_SG --protocol tcp --port 80 --source-group $ALB_SG

# ALB + Target Group + Listener (uses a placeholder TLS policy; upload or use ACM cert later)
VPC_ARN=$(aws ec2 describe-vpcs --vpc-ids $VPC_ID --query "Vpcs[0].VpcId" --output text)
TG=$(aws elbv2 create-target-group --name app-tg --protocol HTTP --port 80 --vpc-id $VPC_ID --target-type instance --query TargetGroups[0].TargetGroupArn --output text)

ALB=$(aws elbv2 create-load-balancer --name app-alb --subnets $PUBA $PUBB --security-groups $ALB_SG --scheme internet-facing --type application --query LoadBalancers[0].LoadBalancerArn --output text)
CERT_ARN="arn:aws:acm:REGION:ACCOUNT:certificate/REPLACE_ME"
aws elbv2 create-listener --load-balancer-arn $ALB --protocol HTTPS --port 443 --certificates CertificateArn=$CERT_ARN --default-actions Type=forward,TargetGroupArn=$TG
```

4) **Private App Nodes (demo)**
Launch two EC2 instances in private subnets and register to target group. (Use SSM Session Manager for access—no SSH inbound needed.)

5) **Endpoints & Logging**
- Create **S3 Gateway Endpoint**; **Interface Endpoints** for STS and Logs.
- Enable **VPC Flow Logs** to CloudWatch Logs.
- Turn on **ALB Access Logs** to S3.
- Enable **CloudTrail** (org‑trail if available).

## Checks
- App reachable via ALB DNS (HTTPS).
- No instance has a public IP; egress works via NAT.
- Flow logs show expected traffic; CloudTrail records API calls.

## Cleanup
- Delete ALB/listener/TG, NAT, EIPs, endpoints, subnets, RTs, IGW, VPC.
