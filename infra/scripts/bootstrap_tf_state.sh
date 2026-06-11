#!/bin/bash
# Phase 0 Bootstrap Script
# Setup Terraform state bucket and locking table

GROUP_ID="cloudmart-dev-2024-ops" # Pre-configured unique ID
REGION="us-east-1"

# Create S3 bucket for state
aws s3api create-bucket \
  --bucket cloudmart-tfstate-${GROUP_ID} \
  --region ${REGION}

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket cloudmart-tfstate-${GROUP_ID} \
  --versioning-configuration Status=Enabled

# Enable server-side encryption
aws s3api put-bucket-encryption \
  --bucket cloudmart-tfstate-${GROUP_ID} \
  --server-side-encryption-configuration '{
    "Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'

# Create DynamoDB table for state locking
aws dynamodb create-table \
  --table-name cloudmart-tfstate-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region ${REGION}
