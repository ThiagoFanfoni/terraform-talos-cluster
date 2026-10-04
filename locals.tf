locals {
  nodes = tomap({ for i in var.nodes : i.node => i })

  node_addresses = toset([for i in var.nodes : i.node])

  endpoint_addresses = toset([
    for i in var.nodes : coalesce(i.endpoint, i.node)
    if i.machine_type == "controlplane"
  ])

  control_plane_nodes = {
    for i in var.nodes : i.node => i
    if i.machine_type == "controlplane"
  }

  worker_nodes = {
    for i in var.nodes : i.node => i
    if i.machine_type != "controlplane"
  }

  control_plane_node_addresses = toset(keys(local.control_plane_nodes))

  worker_node_addresses = toset([
    for i in var.nodes : i.node
    if i.machine_type == "worker"
  ])

  first_controlplane = keys(local.control_plane_nodes)[0]

  bootstrapper = {
    endpoint = coalesce(local.control_plane_nodes[local.first_controlplane].endpoint, local.first_controlplane)
    node     = local.first_controlplane
  }
}
