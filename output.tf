output "kube_config" {
  value = module.aks_cluster.kube_config_raw
}
