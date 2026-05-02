variable "datadog_api_key" {}
variable "datadog_app_key" {}
variable "environment" { default = "production" }
variable "cluster_name" { default = "your-eks-cluster" }
variable "rds_instance_id" { default = "your-postgres-rds" }
