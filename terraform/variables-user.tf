#####
# Global
#####



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


variable "master_envs" {
  description = "Map of string representing environment variables defined in the jmeter master container."
  type        = map(string)
  default     = {}
}

variable "slave_envs" {
  description = "Map of string representing environment variables defined in the jmeter slave container."
  type        = map(string)
  default     = {}
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
