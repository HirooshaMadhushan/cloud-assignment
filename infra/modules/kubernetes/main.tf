terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }
  }
}

provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  token                  = var.cluster_token
}

resource "kubernetes_namespace" "prod" {
  metadata {
    name = var.prod_namespace

    labels = {
      environment = "production"
    }
  }
}

resource "kubernetes_namespace" "staging" {
  metadata {
    name = var.staging_namespace

    labels = {
      environment = "staging"
    }
  }
}
