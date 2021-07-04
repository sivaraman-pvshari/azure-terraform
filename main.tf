terraform {
  required_version = ">=0.14"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.59.0"
    }
  }
}

terraform {
  backend "local" {
    path = ".${var.environment}/terraform.tfstate"
  }
}

module "aks_cluster" {
  source = "./aks_cluster"

  count        = local.count
  environment  = var.environment
  cluster_size = local.cluster_size
}

locals {
  count        = var.environment == 'dev' ? 1 : var.environment == 'staging' ? 2 : var.environment == 'production' ? 3 : 0
  cluster_size = var.environment == 'dev' ? 'Standard_B4ms_v2' : var.environment == 'staging' ? 'Standard_B8ms' : var.environment == 'production' ? 'Standard_D4_v2' : 'Standard_B4ms_v2'
}
