output "deployment_master" {
  value = kubernetes_pod.master
}

output "deployment_slave" {
  value = kubernetes_deployment.slave
}

output "persistent_volume_claim" {
  value = kubernetes_persistent_volume_claim.this
}

output "service" {
  value = kubernetes_service.this
}
