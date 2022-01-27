#####
# Locals
#####

locals {
  annotations = {}
  labels = {
    version    = var.image_version
    managed-by = "terraform"
    name       = "jmeter"
    part-of    = "jmeter"
  }
  port = 60000
}

#####
# Randoms
#####

resource "random_string" "selector" {

  special = false
  length  = 8
}

resource "kubernetes_namespace" "jmeter-namespace" {
  metadata {
    name = var.namespace
  }
}
#####
# Deployment
#####

resource "kubernetes_pod" "master" {

  metadata {
    name      = "${var.PREFIX}-controller"
    namespace = var.namespace
    labels = merge(
      {
        instance  = "${var.PREFIX}-controller"
        component = "master"
      },
      local.labels,
      var.labels,
      var.master_deployment_labels
    )
    annotations = merge(
      {},
      local.annotations,
      var.annotations,
      var.master_deployment_annotations
    )
  }



  spec {

    restart_policy = "Never"
    container {
      image             = "${var.image}:${var.image_version}"
      name              = "jmeter-master"
      image_pull_policy = "IfNotPresent"

      args = [" -Jserver.rmi.ssl.disable=true "]

      resources {
        limits = {
          cpu    = var.master_resources_limits_cpu
          memory = var.master_resources_limits_memory
        }
        requests = {
          cpu    = var.master_resources_requests_cpu
          memory = var.master_resources_requests_memory
        }
      }

      env {
        name  = "CONF_EXEC_IS_SLAVE"
        value = "true"
      }
      dynamic "env" {
        for_each = var.master_envs

        content {
          name  = env.key
          value = env.value
        }
      }

      port {
        container_port = local.port
      }


      dynamic "volume_mount" {
        for_each = var.pvc_access_modes.0 == "ReadWriteMany" ? ["1"] : []

        content {
          name       = "data"
          mount_path = "/jmeter/project"
        }
      }
    }

    dynamic "volume" {
      for_each = var.pvc_access_modes.0 == "ReadWriteMany" ? ["1"] : []

      content {
        name = "data"
        persistent_volume_claim {
          claim_name = kubernetes_persistent_volume_claim.this.metadata.0.name
        }
      }
    }
  }


}


resource "kubernetes_pod" "slave" {

  count = var.JMETER_WORKERS_COUNT
  metadata {
    name      = "${var.PREFIX}-worker${count.index}"
    namespace = var.namespace
    labels = merge(
      {
        instance  = "${var.PREFIX}-worker${count.index}"
        component = "slave"
      },
      local.labels,
      var.labels,
      var.slave_deployment_labels
    )
    annotations = merge(
      {},
      local.annotations,
      var.annotations,
      var.slave_deployment_annotations
    )
  }

  spec {

    restart_policy = "Never"
    container {
      image             = "${var.image}:${var.image_version}"
      name              = "jmeter-slave"
      image_pull_policy = "IfNotPresent"

      args = [" -Jserver.rmi.ssl.disable=true "]

      resources {
        limits = {
          cpu    = var.slave_resources_limits_cpu
          memory = var.slave_resources_limits_memory
        }
        requests = {
          cpu    = var.slave_resources_requests_cpu
          memory = var.slave_resources_requests_memory
        }
      }

      env {
        name  = "CONF_EXEC_IS_SLAVE"
        value = "true"
      }

      dynamic "env" {
        for_each = var.slave_envs

        content {
          name  = env.key
          value = env.value
        }
      }

      port {
        name           = "rmi"
        container_port = 50000
      }

      port {
        name           = "slave"
        container_port = 1099
      }

      dynamic "volume_mount" {
        for_each = var.pvc_access_modes.0 == "ReadWriteMany" ? ["1"] : []

        content {
          name       = "data"
          mount_path = "/jmeter/project"
        }
      }
    }

    dynamic "volume" {
      for_each = var.pvc_access_modes.0 == "ReadWriteMany" ? ["1"] : []

      content {
        name = "data"
        persistent_volume_claim {
          claim_name = kubernetes_persistent_volume_claim.this.metadata.0.name
        }
      }
    }

  }
}

#####
# Pvc
#####

resource "kubernetes_persistent_volume_claim" "this" {
  metadata {
    name      = var.pvc_name
    namespace = var.namespace
    labels = merge(
      {
        instance  = var.pvc_name
        component = "storage"
      },
      local.labels,
      var.labels,
      var.pvc_labels
    )
    annotations = merge(
      {},
      local.annotations,
      var.annotations,
      var.pvc_annotations
    )
  }

  spec {
    access_modes = var.pvc_access_modes
    resources {
      requests = {
        storage = var.pvc_resources_requests_storage
      }
    }
    storage_class_name = var.pvc_storage_class_name
    volume_name        = var.pvc_volume_name
  }
  wait_until_bound = var.pvc_wait_until_bound
}

#####
# Service
#####

resource "kubernetes_service" "service_workers" {
  count = var.JMETER_WORKERS_COUNT
  metadata {
    name      = "${var.PREFIX}-service-worker${count.index}"
    namespace = var.namespace
    labels = merge(
      {
        instance  = "${var.PREFIX}-service-worker${count.index}"
        component = "network"
      },
      local.labels,
      var.labels,
      var.service_labels
    )
    annotations = merge(
      {},
      local.annotations,
      var.annotations,
      var.service_annotations
    )
  }
  spec {
    selector = {
      instance = "${var.PREFIX}-worker${count.index}"
    }

    port {
      name        = "slave"
      port        = 1099
      target_port = "slave"
    }
    cluster_ip = "None"
  }
}
