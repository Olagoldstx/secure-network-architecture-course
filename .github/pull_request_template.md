# 🔒 Secure Network Architecture – Lab PR

## 📌 Summary
- [ ] Lab number & title: (e.g., Week 1 – VPC Foundation)
- [ ] Key changes introduced
- [ ] Lessons learned / notes

---

## ✅ Checklist

### Architecture
- [ ] Updated `docs/architecture.md` with diagrams + notes
- [ ] Added/updated `.mmd` Mermaid diagram in `/mermaid`

### Threat Model
- [ ] Updated `docs/threat-model.md` with STRIDE mapping
- [ ] Documented at least one new threat/mitigation

### Compliance
- [ ] Updated `docs/decisions.md` or `compliance/` with mappings (CIS/NIST/HIPAA if relevant)
- [ ] Evidence stored (logs, configs, screenshots if needed)

### Testing / Validation
- [ ] Verified private subnets have **no IGW route**
- [ ] Validated NAT works for egress
- [ ] Confirmed CloudTrail & Flow Logs capture activity
- [ ] App only reachable through ALB (HTTPS 443)

---

## 🚀 Next Steps
- [ ] Merge into `main` once validated
- [ ] Open new branch for next lab (`feat/weekX-labY`)
