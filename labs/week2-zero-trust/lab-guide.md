# Week 2 – Zero-Trust Segmentation Lab

## 🎯 Objectives
- Implement Zero-Trust segmentation using Transit Gateway (TGW).
- Attach multiple VPCs (App, DB, Shared Services).
- Centralize egress via an Inspection VPC.
- Enforce guardrails with Service Control Policies (SCPs).

## 🧠 Key Concepts
- **Zero-Trust**: Never trust, always verify.
- **TGW**: Central routing hub for VPCs and VPNs.
- **SCPs**: Organization-wide guardrails, override even IAM admin permissions.

## 🛠️ Lab Tasks
1. Create a Transit Gateway.
2. Attach App VPC, DB VPC, and Inspection VPC.
3. Configure TGW route tables (App → DB allowed, App → OnPrem denied).
4. Apply SCPs in AWS Organizations:
   - Deny IAM user creation.
   - Deny disabling CloudTrail.
   - Restrict region usage.
5. Validate connectivity (App ↔ DB, App ↔ OnPrem).

## ✅ Deliverables
- Updated Terraform in `labs/week2-zero-trust/terraform/`.
- Mermaid diagram in `labs/week2-zero-trust/diagrams/zero-trust-tgw.mmd`.
- Updated threat model in `docs/threat-model.md`.

