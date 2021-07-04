resource "azurerm_resource_group" "experiment_aks_resource" {
  name     = "experiment-aks-resource-${var.environment}"
  location = var.region
}

resource "azurerm_virtual_network" "experiment_aks_vpn" {
  name                = "experiment-aks-vpn-${var.environment}"
  location            = azurerm_resource_group.experiment_aks_resource.location
  resource_group_name = azurerm_resource_group.experiment_aks_resource.name
  address_space       = ["10.1.0.0/16"]

  tags {
    environment = var.environment 
  }
}

resource "azurerm_subnet" "experiment_aks_subnet" {
  name                 = "experiment-aks-subnet-${var.environment}"
  resource_group_name  = azurerm_resource_group.experiment_aks_resource.name
  virtual_network_name = azurerm_virtual_network.experiment_aks_vpn
  address_prefixes     = ["10.1.0.0/24"]

  tags {
    environment = var.environment 
  }
}

resource "azurerm_network_profile" "experiment_aks_network" {
  name                = "experiment-aks-network-${var.environment}"
  location            = azurerm_resource_group.experiment_aks_resource.location
  resource_group_name = azurerm_resource_group.experiment_aks_resource.name

  container_network_interface {
    name = "experiment-aks-nic-${var.environment}"

    ip_configuration {
      name      = "experiment-aks-ip-${var.environment}"
      subnet_id = azurerm_subnet.experiment_aks_subnet.id
    }
  }

  tags {
    environment = var.environment 
  }
}

resource "azurerm_kubernetes_cluster" "experiment_aks" {
  name                = "experiment-aks=${var.environment}"
  resource_group_name = azurerm_resource_group.experiment_aks_resource.name
  location            = azurerm_resource_group.experiment_aks_resource.location
  dns_prefix          = "${var.environment}"
  network_profile     = azurerm_network_profile.experiment_aks_network.name
  kubernetes_version  = var.kubernetes_cluster_version
  node_resource_group = azurerm_resource_group.experiment_aks_resource.name

  default_node_pool {
    name       = "primary"
    node_count = var.pool_count
    vm_size    = var.cluster_size
  }

  identity {
    type      =  "SystemAssigned"
  }

  tags {
    environment = var.environment 
  }
}
