output "deployment_master" {
  value = kubernetes_pod.master
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


output "namespace" {
  value = var.namespace
}


output "jmeter_workers_names" {
  value = join(" ", "${kubernetes_pod.slave.*.metadata.0.name}")
}

output "jmeter_contoller_name" {
  value = kubernetes_pod.master.metadata.0.name
}
