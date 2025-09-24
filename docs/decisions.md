
# Architecture Decision Records (ADRs)

## ADR-001: NAT Gateway vs NAT Instance
We choose **NAT Gateway** for managed availability and scale. Cost noted; enforce egress policies with SG + route rules.

## ADR-002: Centralized Logging
All logs (CloudTrail, ALB, VPC Flow Logs, App) land in S3 with lifecycle policies; copy to SIEM later.

## ADR-003: Interface Endpoints
We add **interface endpoints** for STS/Logs to avoid public internet paths from private subnets.
