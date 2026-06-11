terraform {
  backend "s3" {
    bucket         = "cloudmart-tfstate-cloudmart-dev-2024-ops"
    key            = "cloudmart/${terraform.workspace}/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "cloudmart-tfstate-lock"
    encrypt        = true
  }
}
