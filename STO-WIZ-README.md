# OWASP Juice Shop — STO + Wiz Demo

Intentionally vulnerable [OWASP Juice Shop](https://github.com/juice-shop/juice-shop) fork for testing Harness Security Testing Orchestration (STO) with Wiz integration.

## What's included

- **Juice Shop v20.1.0** — upstream vulnerable Node.js app (repo + container scan targets)
- **`iac/`** — intentionally misconfigured Kubernetes and Terraform manifests (IaC scan target)
- **`.harness/pipelines/sto-wiz-juice-shop.yaml`** — CI pipeline with three Wiz orchestration scans + OPA policy gate
- **`.harness/policies/wiz-critical-high-gate.rego`** — Rego policy blocking on critical/high Wiz findings

## Harness setup

1. Ensure Harness text secrets `wiz_access_id` and `wiz_access_token` are set (Wiz CLI v1.x service account). These already exist in AkashSandbox.
2. Import the OPA policy from `.harness/policies/wiz-critical-high-gate.rego` as **Wiz Critical High Gate**.
3. Create a Policy Set **Wiz Critical High Gate** (Custom, On Step) and attach the policy.
4. Create or import the pipeline from `.harness/pipelines/sto-wiz-juice-shop.yaml`.
5. Point the GitHub connector at this repo (`owasp-juice-shop-sto`).

## Pipeline flow

1. Clone repo
2. Build Docker image (`juice-shop:sto-demo`) via DinD
3. Wiz Directory scan (full repo)
4. Wiz IaC scan (`/harness/iac`)
5. Wiz Container scan (local image)
6. OPA policy gate on critical/high findings

Set `fail_on_severity: none` on Wiz steps during baseline validation; the policy step enforces blocking.

## Warning

Never deploy the `iac/` manifests to real infrastructure. Juice Shop is intentionally insecure.
