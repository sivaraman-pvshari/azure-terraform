output "kube_config" {
  value = azurerm_kubernetes_cluster.experiment_aks.kube_config_raw
}
