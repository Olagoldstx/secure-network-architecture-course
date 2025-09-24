
# Lab 02 — Zero‑Trust Segmentation (Multi‑Account + TGW + SCPs)

**Objective:** Move from a single VPC to **multi‑account** with a centralized **inspection VPC** (optional NGFW), **Transit Gateway**, and **SCPs** to enforce guardrails. Introduce **identity‑centric** controls (ABAC) for east‑west traffic and human/admin access.

**Key Tasks:**
- Create **Prod** and **Security** accounts (AWS Organizations)
- Deploy **TGW** and central **Inspection VPC** with GWLB/NGFW (or NACL/SG policies if no NGFW)
- Route **Prod VPC** through **Inspection VPC** for inter‑VPC communication
- Apply **SCPs** (deny `ec2:CreateInternetGateway` outside networking account, deny disabling CloudTrail, etc.)
- Implement **IAM session tags** and ABAC on resources
