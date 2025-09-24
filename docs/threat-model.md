
# Threat Model — Architecture 1 (STRIDE)

| Threat | Control |
|---|---|
| Spoofing | MFA + SSO; endpoint policies; SGs referencing sources |
| Tampering | KMS CMK; S3 Object Lock; versioning |
| Repudiation | Org CloudTrail, immutable logs to S3 |
| Information Disclosure | Private subnets only; WAF/ALB TLS; SG+NACL |
| DoS | WAF, ALB, autoscaling, rate limiting patterns |
| Elevation of Privilege | Least privilege IAM; ABAC; Access Analyzer |

**Analogy:** City checkpoints at each district gate verify badges; cameras record entries; tamper‑evident seals on storage.
