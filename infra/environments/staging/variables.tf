variable "common_tags" {
  type = map(string)
  default = {
    Project     = "cloudmart"
    Environment = "staging"
    Team        = "cloudmart-team"
    ManagedBy   = "terraform"
  }
}

variable "environment" {
  type    = string
  default = "staging"
}

variable "admin_cidr" {
  type        = string
  description = "CIDR block for admin access"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Password for RDS database"
}

variable "ses_domain" {
  type        = string
  description = "Domain for SES"
}

variable "ses_test_email" {
  type        = string
  description = "Test email for SES"
}

variable "alert_email" {
  type        = string
  description = "Email for alerts"
}
