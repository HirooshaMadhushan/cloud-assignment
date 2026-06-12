output "namespace_prod" {
  value = kubernetes_namespace.prod.metadata[0].name
}

output "namespace_staging" {
  value = kubernetes_namespace.staging.metadata[0].name
}
