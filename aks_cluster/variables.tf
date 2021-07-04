variable "environment" {
  type    = string
  default = "dev"
}

variable "region" {
  type    = string
  default = "East US"
}

variable "cluster_size" {
  type    = string
  default = Standard_B4ms_v2
}

variable "pool_count" {
  type    = number
  default = 1
}

variable "kubernetes_cluster_version" {
  type    = string
  default = 1.20.8 
}
