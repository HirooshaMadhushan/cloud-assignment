# CloudMart Kubernetes GitOps

This directory contains the GitOps configuration for CloudMart.

## Structure

- `charts/`: Helm charts for each microservice.
- `base/`: Base Kubernetes manifests (namespaces, network policies, etc.).
- `argocd/`: ArgoCD application manifests.

## Deployment Strategy

- **Production:** Managed by ArgoCD, watches the `main` branch.
- **Staging:** Managed by ArgoCD, watches the `develop` branch.
- **Canary:** `product-service` uses Argo Rollouts for canary deployments with CloudWatch metric analysis.
- **Autoscaling:** `notification-service` uses KEDA to scale based on SQS queue depth.

## Commands

```bash
# Render helm charts locally
helm template k8s/charts/product-service -f k8s/charts/product-service/values-prod.yaml
```
