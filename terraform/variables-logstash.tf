variable "WITH_LOGSTASH" {
  description = "Enable logstash parser for jtl file"
  default     = "false"
}

variable "LOGSTASH_IMAGE_VERSION" {
  description = "Enable logstash parser for jtl file"
  default     = "latest"
}

variable "LOGSTASH_ELASTICSEARCH_HOSTS" {
  description = "Elasticsearch host"
  default     = "http://localhost:9200"
}

variable "LOGSTASH_ELASTICSEARCH_INDEX" {
  description = "Elasticsearch index"
  default     = "jmeter-jtl-%%{+YYYY.MM.dd}"
}

variable "LOGSTASH_ELASTICSEARCH_USER" {
  description = "Elasticsearch user"
  default     = ""
}

variable "LOGSTASH_ELASTICSEARCH_PASSWORD" {
  description = "Elasticsearch password"
  default     = ""
}

variable "LOGSTASH_ELASTICSEARCH_HTTP_COMPRESSION" {
  description = "Elasticsearch use compression"
  default     = "false"
}

variable "LOGSTASH_INFLUXDB_HOST" {
  description = "INFLUXDB host"
  default     = "loalhost"
}

variable "LOGSTASH_INFLUXDB_PORT" {
  description = "INFLUXDB PORT"
  default     = "8086"
}

variable "LOGSTASH_INFLUXDB_USER" {
  description = "INFLUXDB user"
  default     = ""
}

variable "LOGSTASH_INFLUXDB_PASSWORD" {
  description = "INFLUXDB password"
  default     = ""
}

variable "LOGSTASH_INFLUXDB_DB" {
  description = "INFLUXDB DB"
  default     = "jmeter"
}


variable "LOGSTASH_INFLUXDB_MEASUREMENT" {
  description = "INFLUXDB MEASUREMENT DB"
  default     = "jtl"
}

