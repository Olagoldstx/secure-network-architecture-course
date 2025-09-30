# 🏗️ Lab 01 – AWS Foundation (VPC + Subnets + NAT + ALB)

## Prereqs

- AWS CLI configured; region set
- IAM user/role with `AdministratorAccess`

## Steps

1. **Create VPC and Subnets**

```bash
aws ec2 create-vpc --cidr-block 10.0.0.0/16
aws ec2 create-subnet --vpc-id vpc-xxxx --cidr-block 10.0.1.0/24 --availability-zone us-east-1a
aws ec2 create-internet-gateway
aws ec2 create-nat-gateway --subnet-id subnet-xxxx --allocation-id eipalloc-xxxx
aws ec2 create-security-group --group-name alb-sg --description "ALB SG" --vpc-id vpc-xxxx
aws elbv2 create-load-balancer --name app-alb --subnets subnet-xxxx subnet-yyyy --security-groups sg-xxxx

aws ec2 create-vpc-endpoint --vpc-id vpc-xxxx --service-name com.amazonaws.us-east-1.s3 --route-table-ids rtb-xxxx
