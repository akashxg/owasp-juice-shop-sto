# IaC Misconfigurations for STO + Wiz Demo

These files are **intentionally insecure** and exist only to produce findings in Harness STO Wiz IaC scans. Never deploy or apply them to real infrastructure.

## OWASP Top 10 Mapping

| File | Misconfiguration | OWASP Category |
|------|------------------|----------------|
| `kubernetes/juice-shop-deployment.yaml` | `privileged: true`, `runAsUser: 0`, `hostNetwork`, `hostPID` | A05 Security Misconfiguration |
| `kubernetes/juice-shop-deployment.yaml` | Hardcoded DB password and API key in Secret/env | A02 Cryptographic Failures |
| `kubernetes/juice-shop-deployment.yaml` | `LoadBalancer` exposing app publicly, `:latest` tag | A05 Security Misconfiguration |
| `terraform/main.tf` | Security group open to `0.0.0.0/0` on SSH and app port | A05 Security Misconfiguration |
| `terraform/main.tf` | Public S3 bucket with `public-read` ACL | A05 Security Misconfiguration |
| `terraform/main.tf` | IAM policy with `Action: *` on `Resource: *` | A07 Identification and Authentication Failures |
| `terraform/main.tf` | RDS publicly accessible, unencrypted, hardcoded password | A02 Cryptographic Failures |

## Harness STO Configuration

Point the Wiz IaC scan step workspace to `/harness/iac` so only these manifests are scanned.
