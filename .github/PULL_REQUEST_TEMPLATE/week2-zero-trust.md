# 🔒 Secure Network Architecture – Week 2 PR (Zero-Trust, TGW, SCPs)

## 📌 Summary
- [x] Lab: **Week 2 – Zero-Trust Segmentation**
- [x] Key changes:
  - Created **AWS Organizations** accounts: `prod`, `security` (and/or `shared-services`)
  - Deployed **Transit Gateway (TGW)** as hub; attached VPCs (prod, inspection, shared)
  - Implemented **Inspection VPC** (GWLB/NGFW optional) for east-west and egress controls
  - Added **SCPs** (deny disable-CloudTrail, deny IGW creation outside networking acct, restrict regions, etc.)
  - Enforced **identity-centric controls** (SSO/JIT, session tags, ABAC on resources)

## ✅ Architecture Checklist
- [ ] TGW route tables send default from `prod` → `inspection`
- [ ] `prod` and `shared-services` have **no IGW** (centralized egress only)
- [ ] GWLB/NGFW inserted for inspection (or documented SG/NACL policy alternative)
- [ ] VPC Endpoints used for AWS APIs (reduce public egress)
- [ ] Route53 + Private Hosted Zones (optional) documented

## 🛡️ Zero-Trust & IAM
- [ ] Human access via **SSO + MFA**; no long-lived keys for users
- [ ] **ABAC** or **fine-grained RBAC** enforced (session tags → resource conditions)
- [ ] Break-glass role documented + tested (restricted, monitored)
- [ ] Access Analyzer clean (no unintended public or cross-account grants)

## 🧪 Tests / Validation
- [ ] Ping/trace from `prod` to `shared` flows through **inspection**
- [ ] Instances in `prod` cannot reach internet directly (only via inspection NAT/GWLB path)
- [ ] Attempt to create IGW in `prod` **blocked by SCP**
- [ ] Attempt to disable CloudTrail **blocked by SCP**
- [ ] GuardDuty sees expected events; CloudTrail and Flow Logs land in central S3 (KMS + Object Lock)

## 🔐 Threat Model (STRIDE)
- [ ] New threats added (east-west movement, egress exfil, config tampering)
- [ ] Mitigations mapped (GWLB/NGFW, SCPs, ABAC, Detective controls)
- [ ] Sequence diagram updated for an attack path + detection

## 🧾 Compliance Mapping
- [ ] CIS 1.x (IAM), 2.x (logging), 4.x (network) mapped
- [ ] NIST 800-53 (AC, AU, SC) or HIPAA technical safeguards referenced
- [ ] Evidence: screenshots/CLI outputs linked in `docs/` or `tests/`

## 📎 Notes / Decisions
- [ ] ADRs updated: TGW hub-and-spoke, centralized egress, SCP set
- [ ] Cost considerations (NAT, GWLB/NGFW) documented with alternatives

## 🚀 Next
- Merge to `main` after review
- Start Week 3 branch: `feat/week3-inspection-waf`
