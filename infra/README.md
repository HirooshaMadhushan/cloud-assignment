# CloudMart Infrastructure

This directory contains the Terraform modules and scripts required to deploy the core infrastructure for CloudMart on AWS.

## Directory Structure

- `modules/`: Reusable Terraform modules.
  - `vpc/`: Networking infrastructure.
  - `eks/`: EKS cluster, node groups, and IRSA roles.
  - `kms/`: Encryption keys.
  - `ecr/`: Container registries.
  - `monitoring/`: CloudWatch dashboards, WAF, and GuardDuty.
- `environments/`: Environment-specific configurations.
  - `prod/`: Production environment.
  - `staging/`: Staging environment.
- `scripts/`: Helper scripts for post-deployment tasks.

## Getting Started

1. Initialize Terraform:
   ```bash
   cd environments/prod
   terraform init
   ```

2. Plan and Apply:
   ```bash
   terraform apply
   ```

3. Update Kubeconfig:
   ```bash
   aws eks update-kubeconfig --region us-east-1 --name cloudmart-eks
   ```

4. Install Controllers:
   ```bash
   ../../scripts/install_alb_controller.sh
   ../../scripts/install_cluster_autoscaler.sh
   ```
