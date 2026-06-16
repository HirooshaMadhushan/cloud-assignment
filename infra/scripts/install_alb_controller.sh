#!/bin/bash
# Install AWS Load Balancer Controller
# Phase 10.2 of GEMINI.md

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Add IAM policy
curl -o alb-iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json
aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://alb-iam-policy.json

# Create service account
eksctl create iamserviceaccount \
  --cluster=cloudmart-eks-staging \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=arn:aws:iam://${AWS_ACCOUNT_ID}:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve

# Install via Helm
helm repo add eks https://aws.github.io/eks-charts
helm repo update
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=cloudmart-eks-staging \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=us-east-1 \
  --set vpcId=vpc-0dc4fa665cf965639
