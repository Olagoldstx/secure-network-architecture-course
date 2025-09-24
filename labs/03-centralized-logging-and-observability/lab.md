
# Lab 03 — Centralized Logging, Detection & Guardrails

**Objective:** Prove we can **detect**, **alert**, and **respond**.

- Organization CloudTrail → S3 with Object Lock
- VPC Flow Logs + ALB logs → CloudWatch Logs + S3
- GuardDuty + Security Hub enabled
- EventBridge rules for high‑risk API calls (e.g., `PutBucketAcl` public, `CreateAccessKey` for human)
- SNS notifications / Slack webhook (optional)
- Sample detections: unusual geo, creation of public SG, disabling logging
