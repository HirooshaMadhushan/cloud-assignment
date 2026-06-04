#!/bin/bash
# Velero installation and configuration

# Create S3 bucket for Velero
aws s3api create-bucket \
  --bucket cloudmart-velero-backups-${GROUP_ID} \
  --region us-east-1

# Install Velero with AWS plugin
velero install \
  --provider aws \
  --plugins velero/velero-plugin-for-aws:v1.9.0 \
  --bucket cloudmart-velero-backups-${GROUP_ID} \
  --backup-location-config region=us-east-1 \
  --snapshot-location-config region=us-east-1 \
  --secret-file ./credentials-velero

# Schedule automatic daily backup
velero schedule create cloudmart-daily \
  --schedule="0 2 * * *" \
  --include-namespaces cloudmart-prod \
  --ttl 168h   # 7-day retention

# Manual backup (for demo)
velero backup create cloudmart-manual-$(date +%Y%m%d) \
  --include-namespaces cloudmart-prod
