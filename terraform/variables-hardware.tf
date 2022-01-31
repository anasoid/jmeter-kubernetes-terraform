

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
