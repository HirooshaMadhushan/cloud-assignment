variable "cluster_endpoint" {
  type = string
}

variable "cluster_ca_certificate" {
  type = string
}

variable "cluster_token" {
  type = string
}

variable "prod_namespace" {
  type    = string
  default = "cloudmart-prod"
}

variable "staging_namespace" {
  type    = string
  default = "cloudmart-staging"
}
