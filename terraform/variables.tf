#####
# Global
#####

variable "PREFIX" {
  type        = string
  description = "Prefix all name"
  default     = "jmeter"
}


variable "annotations" {
  description = "Map of annotations to apply on all kubernetes resources."
  default     = {}
}

variable "labels" {
  description = "Map of labels to apply on all kubernetes resources."
  default     = {}
}

variable "namespace" {
  description = "Name of the namespace in which to deploy the module."
  default     = "jmeter"
}


#####
# Deployment Master
#####

variable "master_deployment_labels" {
  description = "Map of labels that will be applied on the master's deployment."
  default     = {}
}

variable "master_deployment_annotations" {
  description = "Map of annotations that will be applied on the annotation."
  default     = {}
}

variable "master_deployment_template_labels" {
  description = "Map of labels that will be applied on the master's deployment template."
  default     = {}
}

variable "master_deployment_template_annotations" {
  description = "Map of annotations that will be applied on the master's deployment template."
  default     = {}
}


#####
# Deployment Slave
#####


variable "slave_deployment_labels" {
  description = "Map of labels that will be applied on the slave's deployment."
  default     = {}
}

variable "slave_deployment_annotations" {
  description = "Map of annotations that will be applied on the annotation."
  default     = {}
}

variable "slave_deployment_template_labels" {
  description = "Map of labels that will be applied on the slave's deployment template."
  default     = {}
}

variable "slave_deployment_template_annotations" {
  description = "Map of annotations that will be applied on the slave's deployment template."
  default     = {}
}

variable "JMETER_WORKERS_COUNT" {
  description = "Number of workers"
  default     = 2
}


#####
# Application
#####

variable "image_version" {
  description = "Docker image tag to use for jmeter."
  type        = string
  default     = "5.4-plugins"
}

variable "image" {
  description = "Docker image to use for jmeter."
  default     = "anasoid/jmeter"
}

variable "master_envs" {
  description = "Map of string representing environment variables defined in the jmeter master container."
  type        = map(string)
  default     = {}
}

variable "master_resources_limits_cpu" {
  description = "Describes the maximum amount of CPU resources allowed to the master jmeter container."
  default     = "1"
}

variable "master_resources_limits_memory" {
  description = "Describes the maximum amount of memory resources allowed to the master jmeter container."
  default     = "1024Mi"
}

variable "master_resources_requests_cpu" {
  description = "Describes the minimum amount of CPU requests required to the master jmeter container."
  default     = "100m"
}

variable "master_resources_requests_memory" {
  description = "Describes the minimum amount of memory requests required to the master jmeter container."
  default     = "512Mi"
}

variable "slave_envs" {
  description = "Map of string representing environment variables defined in the jmeter slave container."
  type        = map(string)
  default     = {}
}

variable "slave_resources_limits_cpu" {
  description = "Describes the maximum amount of CPU resources allowed to the slave jmeter container."
  default     = "1"
}

variable "slave_resources_limits_memory" {
  description = "Describes the maximum amount of memory resources allowed to the slave jmeter container."
  default     = "1024Mi"
}

variable "slave_resources_requests_cpu" {
  description = "Describes the minimum amount of CPU requests required to the slave jmeter container."
  default     = "100m"
}

variable "slave_resources_requests_memory" {
  description = "Describes the minimum amount of memory requests required to the slave jmeter container."
  default     = "512Mi"
}

#####
# Pvc
#####

variable "pvc_name" {
  description = "Name of the persistent volume claim that is created."
  default     = "jmeter"
}

variable "pvc_labels" {
  description = "Map of labels that will be applied on the persistent volume claim."
  default     = {}
}

variable "pvc_annotations" {
  description = "Map of annotations that will be applied on the annotation."
  default     = {}
}

variable "pvc_resources_requests_storage" {
  description = "Minimum amount of storage that will be applied to persistent volume claim."
  default     = "5Gi"
}

variable "pvc_storage_class_name" {
  description = "Name of the storage class that will be applied to persistent volume claim."
  type        = string
  default     = null
}

variable "pvc_volume_name" {
  description = "Name of the volume bound to the persistent volume claim."
  type        = string
  default     = ""
}

variable "pvc_wait_until_bound" {
  description = "Whether to wait for the claim to reach Bound state (to find volume in which to claim the space)"
  default     = false
}

variable "pvc_access_modes" {
  description = "A set of the desired access modes the volume should have."
  default     = ["ReadWriteMany"]
}

#####
# Service
#####
variable "service_labels" {
  description = "Map of labels that will be applied on the service."
  default     = {}
}

variable "service_annotations" {
  description = "Map of annotations that will be applied on the annotation."
  default     = {}
}
