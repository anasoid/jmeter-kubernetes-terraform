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
  port = 1099

  jmeter_envs = {
    CONF_EXEC_WORKER_COUNT                 = var.JMETER_WORKERS_COUNT
    JMETER_EXIT                            = "true"
    JMETER_JMX                             = var.JMETER_JMX_FILE
    JMETER_PROPERTIES_FILES                = var.JMETER_PROPERTIES_FILES
    CONF_CSV_DIVIDED_TO_OUT                = var.JMETER_CONF_CSV_DIVIDED_TO_OUT
    CONF_CSV_WITH_HEADER                   = var.JMETER_CONF_CSV_WITH_HEADER
    CONF_CSV_SPLIT_PATTERN                 = var.JMETER_CONF_CSV_SPLIT_PATTERN
    CONF_CSV_SPLIT                         = var.JMETER_CONF_CSV_SPLIT
    CONF_EXEC_TIMEOUT                      = var.JMETER_CONF_EXEC_TIMEOUT
    CONF_COPY_TO_WORKSPACE                 = var.JMETER_CONF_COPY_TO_WORKSPACE
    JMETER_PLUGINS_MANAGER_INSTALL_FOR_JMX = var.JMETER_PLUGINS_MANAGER_INSTALL_FOR_JMX
    JMETER_PLUGINS_MANAGER_INSTALL_LIST    = var.JMETER_PLUGINS_MANAGER_INSTALL_LIST
    CONF_READY_WAIT_FILE                   = var.JMETER_JMX_FILE
  }

  jmeter_master_envs = {
    JMETER_JVM_ARGS    = var.JMETER_MASTER_JVM_ARGS
    JMETER_REPORT_NAME = var.JMETER_DASHBOARD_FOLDER
    JMETER_JTL_FILE    = var.JMETER_RESULTS_FILE

  }
  jmeter_slave_envs = {
    CONF_EXEC_IS_SLAVE = "true"
    JMETER_JVM_ARGS    = var.JMETER_SLAVE_JVM_ARGS
  }

  logstash_envs = {
    INPUT_PATH                     = "/input/jtl"
    PROJECT_NAME                   = var.PROJECT_NAME
    ENVIRONMENT_NAME               = var.ENVIRONMENT_NAME
    TEST_NAME                      = var.TEST_NAME
    EXECUTION_ID                   = var.EXECUTION_ID == "" ? formatdate("YYMMDD-hhmm", timestamp()) : var.EXECUTION_ID
    ELASTICSEARCH_HOSTS            = var.LOGSTASH_ELASTICSEARCH_HOSTS
    ELASTICSEARCH_INDEX            = var.LOGSTASH_ELASTICSEARCH_INDEX
    ELASTICSEARCH_USER             = var.LOGSTASH_ELASTICSEARCH_USER
    ELASTICSEARCH_PASSWORD         = var.LOGSTASH_ELASTICSEARCH_PASSWORD
    ELASTICSEARCH_HTTP_COMPRESSION = var.LOGSTASH_ELASTICSEARCH_HTTP_COMPRESSION
    INFLUXDB_HOST                  = var.LOGSTASH_INFLUXDB_HOST
    INFLUXDB_PORT                  = var.LOGSTASH_INFLUXDB_PORT
    INFLUXDB_USER                  = var.LOGSTASH_INFLUXDB_USER
    INFLUXDB_PASSWORD              = var.LOGSTASH_INFLUXDB_PASSWORD
    INFLUXDB_DB                    = var.LOGSTASH_INFLUXDB_DB
    INFLUXDB_MEASUREMENT           = var.LOGSTASH_INFLUXDB_MEASUREMENT
  }

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
      name              = "jmeter"
      image_pull_policy = "IfNotPresent"

      args = [" -Jserver.rmi.ssl.disable=true  -R ${join(",", [for s in kubernetes_service.service_workers.*.metadata.0.name : "${s}.${var.namespace}"])} ${var.JMETER_EXTRA_CLI_ARGUMENTS} ${var.JMETER_PIPELINE_CLI_ARGUMENTS}"]

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

      # common envs
      dynamic "env" {
        for_each = local.jmeter_envs

        content {
          name  = env.key
          value = env.value
        }
      }
      dynamic "env" {
        for_each = local.jmeter_master_envs

        content {
          name  = env.key
          value = env.value
        }
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

      volume_mount {
        name       = "out"
        mount_path = "/jmeter/out"

      }
    }
    container {
      image             = "busybox"
      name              = "keepalive"
      image_pull_policy = "IfNotPresent"

      command = ["/bin/sh", "-c", "sleep ${var.JMETER_CONF_EXEC_TIMEOUT}"]
      resources {
        limits = {
          cpu    = "50m"
          memory = "32Mi"
        }
        requests = {
          cpu    = "10m"
          memory = "8Mi"
        }
      }
      volume_mount {
        name       = "out"
        mount_path = "/jmeter/out"

      }

    }

    dynamic "container" {
      for_each = var.WITH_LOGSTASH == "true" ? ["1"] : []
      content {
        image             = "anasoid/jmeter-logstash"
        name              = "logstash"
        image_pull_policy = "IfNotPresent"
        resources {
          limits = {
            cpu    = "1100m"
            memory = "1024Mi"
          }
          requests = {
            cpu    = "100m"
            memory = "512Mi"
          }
        }

        dynamic "env" {
          for_each = local.logstash_envs

          content {
            name  = env.key
            value = env.value
          }
        }
        volume_mount {
          name       = "out"
          mount_path = "/input"

        }
      }
    }

    volume {
      name = "out"
      empty_dir {

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
      name              = "jmeter"
      image_pull_policy = "IfNotPresent"

      args = [" -Jserver.rmi.ssl.disable=true  ${var.JMETER_EXTRA_CLI_ARGUMENTS} ${var.JMETER_PIPELINE_CLI_ARGUMENTS}"]

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
        name  = "CONF_EXEC_WORKER_NUMBER"
        value = count.index
      }
      env {
        name  = "JMETER_LOG_FILE"
        value = "jmeter-${count.index}.log"
      }


      # common envs
      dynamic "env" {
        for_each = local.jmeter_envs

        content {
          name  = env.key
          value = env.value
        }
      }
      dynamic "env" {
        for_each = local.jmeter_slave_envs

        content {
          name  = env.key
          value = env.value
        }
      }
      dynamic "env" {
        for_each = var.slave_envs

        content {
          name  = env.key
          value = env.value
        }
      }

      port {
        name           = "slave"
        container_port = local.port
      }
      startup_probe {
        period_seconds    = 5
        failure_threshold = 60
        tcp_socket {
          port = local.port
        }
      }


      volume_mount {
        name       = "out"
        mount_path = "/jmeter/out"

      }
    }
    container {
      image             = "busybox"
      name              = "keepalive"
      image_pull_policy = "IfNotPresent"

      command = ["/bin/sh", "-c", "sleep ${var.JMETER_CONF_EXEC_TIMEOUT}"]
      resources {
        limits = {
          cpu    = "50m"
          memory = "32Mi"
        }
        requests = {
          cpu    = "10m"
          memory = "8Mi"
        }
      }
      volume_mount {
        name       = "out"
        mount_path = "/jmeter/out"

      }

    }

    volume {
      name = "out"
      empty_dir {

      }
    }

  }
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
      port        = local.port
      target_port = "slave"
    }
    cluster_ip = "None"
  }
}
