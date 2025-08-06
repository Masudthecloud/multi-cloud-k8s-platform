variable "location" {
  type    = string
  default = "eastus"
}

variable "resource_group_name" {
  type    = string
  default = "multi-cloud-aks-rg"
}

variable "aks_cluster_name" {
  type    = string
  default = "multi-cloud-aks-cluster"
}
