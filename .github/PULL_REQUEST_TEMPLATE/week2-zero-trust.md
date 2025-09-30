# 🔐 Secure Network Architecture – Week 2 PR (Zero-Trust, TGW, SCPs)

## 📌 Summary

- [x] Lab: **Week 2 – Zero-Trust Segmentation**
- [ ] Key changes:
  - Created **AWS Organizations** accounts: `prod`, `security` (and/or `shared-services`)
  - Deployed **Transit Gateway (TGW)** as hub; attached VPCs (prod, inspection, shared)
  - Implemented **Inspection VPC** (GWLB/NGFW optional) for east-west and egress
  - Added **SCPs** (deny disable-CloudTrail, deny IGW creation outside networking)
  - Enforced **identity-centric controls** (SSO/JIT, session tags, ABAC on resources)

## ✅ Architecture Checklist

- [ ] TGW route tables send default from `prod` → `inspection`
- [ ] `prod` and `shared-services` have **no IGW** (centralized egress only)
- [ ] GWLB/NGFW inserted for inspection (or documented SG/NACL policy alternatives)
- [ ] VPC Endpoints used for AWS APIs (reduce public egress)
- [ ] Route53 + Private Hosted Zones (optional) documented

## 🛡️ Zero-Trust & IAM

- [ ] Human access via **SSO + MFA**; no long-lived keys for users

## 🔥 Threat Model (STRIDE)

- [ ] New threats added (east-west movement, egress exfil, config tampering)
- [ ] Mitigations mapped (GWLB/NGFW, SCPs, ABAC, Detective controls)
- [ ] Sequence diagram updated for an attack path + detection

## 📋 Compliance Mapping

- [ ] CIS 1.x (IAM), 2.x (logging), 4.x (network) mapped
- [ ] NIST 800-53 (AC, AU, SC) or HIPAA technical safeguards referenced
- [ ] Evidence: screenshots/CLI outputs linked in `docs/` or `tests/`

## 📝 Notes / Decisions

- [ ] ADRs updated: TGW hub-and-spoke, centralized egress, SCP set
- [ ] Cost considerations (NAT, GWLB/NGFW) documented with alternatives

## 🚀 Next

- Merge to `main` after review
- Start Week 3 branch: `feat/week3-inspection-waf`

