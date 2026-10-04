output "cluster_endpoint" {
  description = "Kubernetes API endpoint URL configured for the cluster."
  value       = module.example.cluster_endpoint
}

output "cluster_name" {
  description = "Name assigned to the Talos Kubernetes cluster."
  value       = module.example.cluster_name
}

output "cluster_nodes" {
  description = "Set of addresses for all Talos nodes in the cluster."
  value       = module.example.cluster_nodes
}

output "control_plane_nodes" {
  description = "Set of addresses for Talos control plane nodes."
  value       = module.example.control_plane_nodes
}

output "kubeconfig" {
  description = "Sensitive Kubernetes client configuration for accessing the cluster with kubectl."
  value       = module.example.kubeconfig
  sensitive   = true
}

output "kubernetes_version" {
  description = "Kubernetes version used in the generated Talos machine configurations."
  value       = module.example.kubernetes_version
}

output "talos_cluster_endpoints" {
  description = "Set of control plane addresses used as Talos API endpoints."
  value       = module.example.talos_cluster_endpoints
}

output "talos_nodes" {
  description = "Map of Talos node addresses to their roles, versions, images, endpoints, upgrade settings, and lifecycle settings."
  value       = module.example.talos_nodes
}

output "talos_version" {
  description = "Talos version contract used to generate compatible machine secrets and configurations."
  value       = module.example.talos_version
}

output "talosconfig" {
  description = "Sensitive Talos client configuration scoped to the cluster nodes and control plane endpoints."
  value       = module.example.talosconfig
  sensitive   = true
}

output "worker_nodes" {
  description = "Set of addresses for Talos worker nodes."
  value       = module.example.worker_nodes
}
