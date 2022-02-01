#####
# Global
#####

variable "PREFIX" {
  type        = string
  description = "Prefix all name"
  default     = "jmeter"
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
variable "JMETER_JMX_FILE" {
  type        = string
  description = "JMX file"
}

variable "JMETER_RESULTS_FILE" {
  type    = string
  default = "results.jtl"
}

variable "JMETER_DASHBOARD_FOLDER" {
  type    = string
  default = "dashboard"
}

variable "JMETER_EXTRA_CLI_ARGUMENTS" {
  type        = string
  default     = ""
  description = "Arguments add custom environement variable"
}

variable "JMETER_PIPELINE_CLI_ARGUMENTS" {
  type        = string
  default     = ""
  description = "Arguments add by pipeline, not by custom environement variable"
}

#Jmeter config
variable "JMETER_PROPERTIES_FILES" {
  type    = string
  default = ""
}

variable "JMETER_CONF_CSV_DIVIDED_TO_OUT" {
  type    = string
  default = "true"
}

variable "JMETER_CONF_CSV_WITH_HEADER" {
  type    = string
  default = "true"
}

variable "JMETER_CONF_CSV_SPLIT_PATTERN" {
  type    = string
  default = "**_split.csv"
}

variable "JMETER_CONF_CSV_SPLIT" {
  type    = string
  default = "true"
}

variable "JMETER_CONF_EXEC_TIMEOUT" {
  type    = string
  default = "7200"
}

variable "JMETER_CONF_COPY_TO_WORKSPACE" {
  type    = string
  default = "false"
}
variable "JMETER_PLUGINS_MANAGER_INSTALL_FOR_JMX" {
  type    = string
  default = "true"
}

variable "JMETER_PLUGINS_MANAGER_INSTALL_LIST" {
  type    = string
  default = ""
}


variable "PROJECT_NAME" {
  type    = string
  default = "myproject"
}
variable "ENVIRONMENT_NAME" {
  type    = string
  default = "myenv"
}
variable "TEST_NAME" {
  type    = string
  default = "global"
}
variable "EXECUTION_ID" {
  type    = string
  default = ""
}
