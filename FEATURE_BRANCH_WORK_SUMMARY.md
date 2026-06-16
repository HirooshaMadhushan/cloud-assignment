# Feature Branch Work Summary

Generated from the remote feature branches under `origin/feature/*`.

Branches intentionally excluded: `main`, `develop`, `origin/main`, and `origin/develop`.

Baseline used for comparison: initial commit `e8e37a1`.

## Branches Reviewed

| Person | Feature branch | Latest commit reviewed |
| --- | --- | --- |
| Chathumi | `origin/feature/chathumi-backend-cicd` | `e8effab` |
| Hirusha | `origin/feature/hirusha-core-infra` | `ecebe81` |
| Lalithya | `origin/feature/lalithya-gitops` | `a9774bc` |
| Randil | `origin/feature/randil-persistence` | `ece4024` |
| Sethmi | `origin/feature/sethmi-security-sre` | `c699611` |

## Chathumi - Backend CI/CD

Branch: `origin/feature/chathumi-backend-cicd`

Summary: Chathumi worked on backend service cloud integrations, service containerization, and GitHub Actions CI/CD workflows.

What was done:

- Added a DynamoDB adapter for `product-service`.
- Added SQS publishing support for `order-service`.
- Added SQS consumer and SES adapter support for `notification-service`.
- Updated backend service dependencies, including generated lock files for Node services.
- Updated Dockerfiles for frontend, user, product, order, and notification services.
- Added GitHub Actions build and deployment workflows.
- Added container image versioning changes for all major services:
  - `product-service`
  - `order-service`
  - `notification-service`
  - `user-service`
  - `frontend`
- Added CI/CD setup documentation.
- Refactored SDK integration structure and updated workflow environment variables.

Main files and areas changed:

- `.github/workflows/ci.yml`
- `.github/workflows/cd.yml`
- `docs/CI_CD_SETUP.md`
- `services/product-service/app.py`
- `services/order-service/src/index.js`
- `services/notification-service/src/index.js`
- Service Dockerfiles under `services/*/Dockerfile`

Change size: 13 commits, 16 files changed.

## Hirusha - Core Infrastructure

Branch: `origin/feature/hirusha-core-infra`

Summary: Hirusha built the main Terraform infrastructure foundation for AWS networking, EKS, image repositories, encryption, monitoring, and environment setup.

What was done:

- Added Terraform VPC module with public and private subnets.
- Added KMS module for cluster encryption.
- Added EKS cluster and managed node group infrastructure.
- Added IAM/IRSA-related configuration for service access.
- Added ECR repository infrastructure for microservices.
- Added CloudWatch monitoring, dashboard, GuardDuty, and WAF-related infrastructure.
- Added production and staging Terraform environment configurations.
- Added Terraform backend configuration and version constraints.
- Added example `terraform.tfvars` files for prod and staging.
- Added infrastructure documentation.
- Added bootstrap script for Terraform remote state.
- Added scripts to install AWS Load Balancer Controller and Cluster Autoscaler.
- Added `.gitignore` for infrastructure files.

Main files and areas changed:

- `infra/modules/vpc/*`
- `infra/modules/eks/*`
- `infra/modules/ecr/*`
- `infra/modules/kms/*`
- `infra/modules/monitoring/*`
- `infra/environments/prod/*`
- `infra/environments/staging/*`
- `infra/scripts/*`
- `infra/README.md`

Change size: 15 commits, 32 files changed.

## Lalithya - GitOps

Branch: `origin/feature/lalithya-gitops`

Summary: Lalithya worked on Kubernetes GitOps deployment structure, Helm charts, Argo CD manifests, rollout strategy, autoscaling, and deployment workflows.

What was done:

- Added base Helm chart structure for the application services.
- Added service-specific Helm charts for:
  - `frontend`
  - `product-service`
  - `order-service`
  - `user-service`
  - `notification-service`
- Added staging and production Helm values.
- Added Argo CD application manifest for production.
- Added base Kubernetes manifests and reorganized GitOps manifests.
- Replaced older flat Kubernetes manifests with a structured `k8s/base` and `k8s/charts` layout.
- Added Kubernetes namespaces, network policies, Kyverno non-root policy, and X-Ray manifest.
- Added canary rollout support for `product-service`.
- Added KEDA autoscaling configuration for `notification-service`.
- Added CI/CD workflows for automated deployment.
- Fixed service names, selectors, service account naming, and Helm template variables across services.
- Added GitOps/deployment documentation.

Main files and areas changed:

- `.github/workflows/ci.yml`
- `.github/workflows/cd.yml`
- `k8s/argocd/applications/cloudmart-prod.yaml`
- `k8s/base/*`
- `k8s/charts/frontend/*`
- `k8s/charts/product-service/*`
- `k8s/charts/order-service/*`
- `k8s/charts/user-service/*`
- `k8s/charts/notification-service/*`
- `k8s/README.md`

Change size: 15 commits, 65 files changed.

## Randil - Persistence

Branch: `origin/feature/randil-persistence`

Summary: Randil focused on persistence and supporting cloud infrastructure, including database, queue, secrets, email, service identity, monitoring, and Helm deployment assets.

What was done:

- Added Terraform module for PostgreSQL RDS.
- Added Terraform module for DynamoDB tables.
- Added Terraform module for SQS queues.
- Added Terraform module for SES resources.
- Added Terraform module for Secrets Manager integration.
- Added IRSA roles for DynamoDB and SQS access.
- Added database subnet group and network policy configuration.
- Added ECR repositories for services.
- Added CloudWatch and GuardDuty monitoring infrastructure.
- Added Terraform S3 backend configuration.
- Standardized Terraform variables for production.
- Added production Terraform provider and variable files.
- Added Helm charts for application services under `k8s/charts`.
- Added Argo CD application manifest and supporting Kubernetes base resources.
- Added X-Ray, Kyverno, network policy, namespace, HPA, PDB, and service account manifests.

Main files and areas changed:

- `infra/modules/rds/*`
- `infra/modules/dynamodb/*`
- `infra/modules/sqs/*`
- `infra/modules/ses/*`
- `infra/modules/secrets/*`
- `infra/modules/eks/*`
- `infra/modules/ecr/*`
- `infra/modules/monitoring/*`
- `infra/environments/prod/*`
- `k8s/argocd/applications/cloudmart-prod.yaml`
- `k8s/base/*`
- `k8s/charts/*`

Change size: 12 commits, 81 files changed.

## Sethmi - Security and SRE

Branch: `origin/feature/sethmi-security-sre`

Summary: Sethmi worked on security, monitoring, reliability, and backup-related infrastructure and Kubernetes policies.

What was done:

- Added AWS WAF configuration.
- Added GuardDuty monitoring configuration, including EBS volume datasource enablement.
- Added CloudWatch dashboards.
- Added CloudWatch monitoring and budget alert support.
- Added Kubernetes NetworkPolicies.
- Added Kyverno security policy to restrict root containers.
- Added production and staging namespace manifests.
- Added Velero backup setup script.
- Adjusted monitoring thresholds.
- Updated security policy exceptions.
- Added security deployment notes.
- Refactored SNS topic tagging by adding a `Name` tag.

Main files and areas changed:

- `docs/security-notes.md`
- `infra/modules/monitoring/*`
- `k8s/base/kyverno-policies/restrict-root.yaml`
- `k8s/base/network-policies/*`
- `k8s/base/namespaces.yaml`
- `k8s/velero/setup-velero.sh`

Change size: 13 commits, 11 files changed.

## Notes

- The summaries above are based only on feature branch history and diffs from the initial repository commit.
- Remote feature branches were refreshed before this report was written; no `origin/feature/*` branch changed during that fetch.
- Local feature branches were not used because some were stale compared with their remote counterparts.
