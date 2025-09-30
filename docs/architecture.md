# 🏗️ Architecture

## Goals

- Resilient, least-privilege network
- Zero-Trust enforced everywhere
- Centralized inspection & logging

## Address Space

- VPC CIDR: `10.0.0.0/16`
- Subnets: public/private split across AZs
- Route tables aligned with Zero-Trust principles

## Security Controls

- SGs: ALB allows :443 from internet
- NACLs: restrict lateral movement
- Flow Logs + GuardDuty enabled
- SCPs: deny disable-CloudTrail, deny IGW creation

## Mermaid — Data Flow

```mermaid
flowchart TD
    User --> ALB --> App --> DB
    CloudTrail --> GuardDuty
    Logs --> S3 --> Security

