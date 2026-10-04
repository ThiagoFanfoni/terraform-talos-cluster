output "cluster_endpoint" {
  description = "Kubernetes API endpoint URL configured for the cluster."
  value       = var.cluster_endpoint
}

output "cluster_name" {
  description = "Name assigned to the Talos Kubernetes cluster."
  value       = data.talos_client_configuration.this.cluster_name
}

output "cluster_nodes" {
  description = "Set of addresses for all Talos nodes in the cluster."
  value       = toset(data.talos_client_configuration.this.nodes)
}

output "control_plane_nodes" {
  description = "Set of addresses for Talos control plane nodes."
  value       = local.control_plane_node_addresses
}

output "kubeconfig" {
  description = "Sensitive Kubernetes client configuration for accessing the cluster with kubectl."
  value       = talos_cluster_kubeconfig.this.kubeconfig_raw
  sensitive   = true
}

output "kubernetes_version" {
  description = "Kubernetes version used in the generated Talos machine configurations."
  value = one(toset([
    for v in data.talos_machine_configuration.this : v.kubernetes_version
  ]))
}

output "talos_cluster_endpoints" {
  description = "Set of control plane addresses used as Talos API endpoints."
  value       = toset(data.talos_client_configuration.this.endpoints)
}

output "talos_nodes" {
  description = "Map of Talos node addresses to their roles, versions, images, endpoints, upgrade settings, and lifecycle settings."
  value = tomap(
    merge(
      {
        for k, v in data.talos_machine_configuration.this : k => {
          drain_on_upgrade           = talos_machine.controlplane[k].drain_on_upgrade
          endpoint                   = talos_machine.controlplane[k].endpoint
          image                      = talos_machine.controlplane[k].image
          kubernetes_version         = v.kubernetes_version
          machine_configuration_hash = talos_machine.controlplane[k].machine_configuration_hash
          machine_type               = v.machine_type
          node                       = talos_machine.controlplane[k].node
          on_destroy                 = talos_machine.controlplane[k].on_destroy
          reboot_mode                = talos_machine.controlplane[k].reboot_mode
          talos_version              = v.talos_version
        }
        if v.machine_type == "controlplane"
      },

      {
        for k, v in data.talos_machine_configuration.this : k => {
          drain_on_upgrade           = talos_machine.worker[k].drain_on_upgrade
          endpoint                   = talos_machine.worker[k].endpoint
          image                      = talos_machine.worker[k].image
          kubernetes_version         = v.kubernetes_version
          machine_configuration_hash = talos_machine.worker[k].machine_configuration_hash
          machine_type               = v.machine_type
          node                       = talos_machine.worker[k].node
          on_destroy                 = talos_machine.worker[k].on_destroy
          reboot_mode                = talos_machine.worker[k].reboot_mode
          talos_version              = v.talos_version
        }
        if v.machine_type != "controlplane"
      }
    )
  )
}

output "talos_version" {
  description = "Talos version contract used to generate compatible machine secrets and configurations."
  value       = talos_machine_secrets.this.talos_version
}

output "talosconfig" {
  description = "Sensitive Talos client configuration scoped to the cluster nodes and control plane endpoints."
  value       = data.talos_client_configuration.this.talos_config
  sensitive   = true
}

output "worker_nodes" {
  description = "Set of addresses for Talos worker nodes."
  value       = local.worker_node_addresses
}
