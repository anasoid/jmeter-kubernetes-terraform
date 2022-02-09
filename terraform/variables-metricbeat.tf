variable "WITH_JOLOKIA" {
  description = "Enable jolokia"
  default     = "false"
}

variable "METRICBEAT_IMAGE_VERSION" {
  description = "metric beat version "
  default     = "7.17.0"
}

variable "METRICBEAT_ELASTICSEARCH_HOSTS" {
  description = "Elasticsearch host"
  default     = "http://localhost:9200"
}

variable "METRICBEAT_ELASTICSEARCH_USER" {
  description = "Elasticsearch user"
  default     = ""
}

variable "METRICBEAT_ELASTICSEARCH_PASSWORD" {
  description = "Elasticsearch password"
  default     = ""
}

