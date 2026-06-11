variable "common_tags" {
  type = map(string)
}

variable "environment" {
  type = string
}

variable "data_subnet_ids" {
  type = list(string)
}

variable "kms_key_arn" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "rds_sg_id" {
  type = string
}
