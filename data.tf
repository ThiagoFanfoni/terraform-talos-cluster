data "talos_machine_configuration" "this" {
  for_each = local.nodes

  cluster_endpoint   = var.cluster_endpoint
  cluster_name       = var.cluster_name
  kubernetes_version = var.kubernetes_version
  config_patches     = each.value.config_patches
  docs               = var.include_machine_configuration_docs
  examples           = var.include_machine_configuration_examples
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  machine_type       = each.value.machine_type
  talos_version      = var.talos_version
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = local.endpoint_addresses
  nodes                = local.node_addresses
}

data "talos_cluster_health" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = local.endpoint_addresses

  control_plane_nodes = local.control_plane_node_addresses
  worker_nodes        = local.worker_node_addresses

  skip_kubernetes_checks = false

  timeouts = {
    read = "15m"
  }

  depends_on = [
    talos_machine.controlplane,
    talos_machine.worker,
    talos_machine_bootstrap.this,
  ]
}
