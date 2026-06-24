# OWASP Juice Shop — STO + Wiz Demo

Intentionally vulnerable [OWASP Juice Shop v20.1.0](https://github.com/juice-shop/juice-shop) fork for testing Harness Security Testing Orchestration (STO) with Wiz.

**GitHub:** https://github.com/akashxg/owasp-juice-shop-sto (branch `sto-wiz-demo`)

## What's included

| Path | Purpose |
|------|---------|
| Juice Shop source (upstream) | Repo + container scan targets (npm CVEs, secrets, SAST) |
| [`iac/`](iac/) | Intentional K8s + Terraform misconfigs for Wiz IaC scans |
| [`.harness/pipelines/sto-wiz-juice-shop.yaml`](.harness/pipelines/sto-wiz-juice-shop.yaml) | Baseline CI pipeline — 3 Wiz orchestration scans (`fail_on_severity: none`) |
| [`.harness/pipelines/sto-wiz-juice-shop-policy-step.yaml`](.harness/pipelines/sto-wiz-juice-shop-policy-step.yaml) | Optional OPA policy step snippet (merge after baseline validation) |
| [`.harness/policies/wiz-critical-high-gate.rego`](.harness/policies/wiz-critical-high-gate.rego) | Rego policy blocking on critical/high Wiz findings |

## Harness resources (AkashSandbox)

| Resource | Identifier | Status |
|----------|------------|--------|
| Pipeline | `sto_wiz_juice_shop` | Created in Harness |
| OPA Policy | `Wiz_Critical_High_Gate` | Created |
| Policy Set | `Wiz_Critical_High_Gate` (onstep, enforced) | Created |
| Wiz secrets | `wiz_access_id`, `wiz_access_token` | Pre-existing |
| Docker connector | `Harness_Docker_Connector` | Available |

**Pipeline URL:** https://app.harness.io/ng/account/EeRjnXTnS4GrLG5VNNJZUw/all/orgs/sandbox/projects/AkashSandbox/pipelines/sto_wiz_juice_shop/pipeline-studio

## Pipeline flow

1. **Clone** public repo via Run step (no GitHub connector dependency)
2. **Wiz Directory** scan — full codebase (`config: wiz-directory`)
3. **Wiz IaC** scan — `/harness/iac` only (`config: wiz-iac-templates`)
4. **Wiz Container** scan — `bkimminich/juice-shop:latest` from Docker Hub

## Enable OPA gate (after baseline)

1. Confirm findings appear in the execution **Security Tests** tab.
2. In Pipeline Studio, add the **Policy** step from [`.harness/pipelines/sto-wiz-juice-shop-policy-step.yaml`](.harness/pipelines/sto-wiz-juice-shop-policy-step.yaml) after the Wiz scans.
3. Re-run — pipeline should block when `NEW_CRITICAL` or `NEW_HIGH` > 0 on any Wiz step.

## OWASP mapping (static scans)

| Scan | Expected findings | OWASP |
|------|-------------------|-------|
| Repo | npm CVEs (jsonwebtoken, crypto-js, vm2), hardcoded secrets | A02, A06 |
| IaC | Open SG, public S3, privileged pod, wildcard IAM | A05, A07 |
| Container | Image-layer CVEs in Juice Shop image | A06 |

Runtime flaws (SQLi, XSS at runtime) require DAST (e.g. ZAP) — not in scope for Wiz STO.

## Warning

Never deploy `iac/` manifests to real infrastructure. Juice Shop is intentionally insecure.
