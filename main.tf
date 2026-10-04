resource "talos_machine_secrets" "this" {
  talos_version = var.talos_version
}

ephemeral "talos_cluster_kubeconfig" "this" {
  cluster_name    = var.cluster_name
  endpoint        = var.cluster_endpoint
  machine_secrets = talos_machine_secrets.this.machine_secrets
}

resource "talos_machine" "controlplane" {
  for_each = local.control_plane_nodes

  client_configuration            = talos_machine_secrets.this.client_configuration
  drain_on_upgrade                = each.value.drain_on_upgrade
  endpoint                        = each.value.endpoint
  ignore_kubernetes_upgrade_drift = each.value.ignore_kubernetes_upgrade_drift
  image                           = each.value.image
  kubeconfig_wo                   = ephemeral.talos_cluster_kubeconfig.this.kubeconfig_raw
  machine_configuration           = data.talos_machine_configuration.this[each.key].machine_configuration
  node                            = each.key
  reboot_mode                     = each.value.reboot_mode

  on_destroy = {
    graceful = each.value.on_destroy.graceful
    reboot   = each.value.on_destroy.reboot
    reset    = each.value.on_destroy.reset
  }
}

resource "talos_machine" "worker" {
  for_each = local.worker_nodes

  client_configuration            = talos_machine_secrets.this.client_configuration
  drain_on_upgrade                = each.value.drain_on_upgrade
  endpoint                        = each.value.endpoint
  ignore_kubernetes_upgrade_drift = each.value.ignore_kubernetes_upgrade_drift
  image                           = each.value.image
  kubeconfig_wo                   = ephemeral.talos_cluster_kubeconfig.this.kubeconfig_raw
  machine_configuration           = data.talos_machine_configuration.this[each.key].machine_configuration
  node                            = each.key
  reboot_mode                     = each.value.reboot_mode

  on_destroy = {
    graceful = each.value.on_destroy.graceful
    reboot   = each.value.on_destroy.reboot
    reset    = each.value.on_destroy.reset
  }

  depends_on = [talos_machine.controlplane]
}

resource "talos_machine_bootstrap" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoint             = local.bootstrapper.endpoint
  node                 = local.bootstrapper.node

  lifecycle {
    ignore_changes = [endpoint, node]
  }

  depends_on = [talos_machine.controlplane]
}

resource "talos_cluster_kubeconfig" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoint             = local.bootstrapper.endpoint
  node                 = local.bootstrapper.node

  depends_on = [
    data.talos_cluster_health.this,
    talos_machine_bootstrap.this,
  ]
}
