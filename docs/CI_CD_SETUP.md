# CI/CD Setup Documentation

This repository uses GitHub Actions for continuous integration and continuous deployment.

## Workflows

### 1. CI Workflow (`.github/workflows/ci.yml`)
Triggers on: `push` to `main`, `develop`, and `feature/**`, and on `pull_request`.
- Runs Linting and Unit Tests for all microservices.
- Builds, Scans (with Trivy for vulnerabilities), and Pushes Docker images to Amazon ECR.
- Validates Kubernetes manifests with `kubeconform`.

### 2. CD Workflow (`.github/workflows/cd.yml`)
Triggers on: `push` to `main` and `develop`.
- **Staging (`develop` branch):** Deploys all services to the `cloudmart-staging` namespace via Helm. Runs smoke tests.
- **Production (`main` branch):** Deploys to `cloudmart-prod` using Helm. Uses Argo Rollouts for `product-service` canary deployments.

## Setup Requirements

The following secrets must be configured in GitHub:
- `AWS_ACCOUNT_ID`: Your AWS Account ID for OIDC authentication.

The workflows rely on AWS IAM Roles for Service Accounts (IRSA) via OIDC to authenticate securely without long-lived credentials.