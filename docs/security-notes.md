# Security Deployment Notes

## Overview
This document outlines the security measures implemented for CloudMart.

## Implemented Features
- **AWS WAF:** Protects the frontend from common web exploits.
- **GuardDuty:** Continuous security monitoring for threat detection.
- **NetworkPolicies:** Enforces a default-deny stance with specific allow rules for microservice communication.
- **Kyverno Policies:** Ensures best practices like non-root containers and restricted image registries.
- **Monitoring:** CloudWatch dashboards and budget alerts for SRE observability.
- **Disaster Recovery:** Velero setup for automated backups and namespace-level restoration.

## Maintenance
- Regularly review GuardDuty findings in the AWS Console.
- Monitor budget alerts to avoid unexpected costs.
- Verify daily Velero backups.
