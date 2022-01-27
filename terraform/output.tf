output "deployment_master" {
  value = kubernetes_pod.master
}

output "persistent_volume_claim" {
  value = kubernetes_persistent_volume_claim.this
}

output "service" {
  value = kubernetes_service.service_workers
}



output "service_name" {
  value = kubernetes_service.service_workers.*.metadata.0.name
}



output "jmeter_workers_ids" {
  value = kubernetes_pod.slave.*.id
}


output "jmeter_workers" {
  value = kubernetes_pod.slave
}



output "service_slaves" {
  value = join(" ", [for s in kubernetes_service.service_workers.*.metadata.0.name : "${s}.${var.namespace}"])
}

