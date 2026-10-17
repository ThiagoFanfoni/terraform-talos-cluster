# Bare-metal cluster example

This example configures a Talos Linux cluster with one control plane and three
workers. It creates an Image Factory schematic with compatible system
extensions, obtains its Secure Boot installer image, and supplies that image to
the module through a shared installation patch.

The nodes must already be booted into Talos maintenance mode. Complete the
[Secure Boot setup](../../README.md#secure-boot-setup) before applying this
configuration.

> Replace the example IP addresses, versions, extensions, and installation disk
> before applying. The installation patch targets `/dev/nvme0n1` with
> `wipe: true`, which erases the disk on every configured node.

## Identify disks and network interfaces

Before applying the configuration, use `talosctl` to inspect each node while it
is in maintenance mode. Replace `192.168.65.10` with the node's current IP
address, rather than the virtual IP (VIP), and repeat for the other nodes:

```sh
# List disks to identify the installation target.
talosctl get disks --insecure --nodes 192.168.65.10

# List network interfaces and their link status.
talosctl get links --insecure --nodes 192.168.65.10
```

Use the disk information to update `provisioning.diskSelector.match` in
[`config_patches/install.yaml`](config_patches/install.yaml). The installation
patch is shared by all nodes, so confirm that its selector matches the intended
disk on each node.

Use the interface name in the `ID` column to update `link` in
[`config_patches/vip.yaml`](config_patches/vip.yaml) for the control plane.
Set `name` in that patch to the intended VIP and use the same address in
`cluster_endpoint` in [`main.tf`](main.tf).

The `--insecure` flag accesses the maintenance API before a machine configuration
has been applied. See the [Talos CLI reference](https://docs.siderolabs.com/talos/latest/reference/cli)
for command details.

<!-- BEGIN_TF_DOCS -->
<!-- markdownlint-disable -->


## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_base_image"></a> [base\_image](#module\_base\_image) | ../base_image/ | n/a |
| <a name="module_example"></a> [example](#module\_example) | ../.. | n/a |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Kubernetes API endpoint URL configured for the cluster. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name assigned to the Talos Kubernetes cluster. |
| <a name="output_cluster_nodes"></a> [cluster\_nodes](#output\_cluster\_nodes) | Set of addresses for all Talos nodes in the cluster. |
| <a name="output_control_plane_nodes"></a> [control\_plane\_nodes](#output\_control\_plane\_nodes) | Set of addresses for Talos control plane nodes. |
| <a name="output_kubeconfig"></a> [kubeconfig](#output\_kubeconfig) | Sensitive Kubernetes client configuration for accessing the cluster with kubectl. |
| <a name="output_kubernetes_version"></a> [kubernetes\_version](#output\_kubernetes\_version) | Kubernetes version used in the generated Talos machine configurations. |
| <a name="output_talos_cluster_endpoints"></a> [talos\_cluster\_endpoints](#output\_talos\_cluster\_endpoints) | Set of control plane addresses used as Talos API endpoints. |
| <a name="output_talos_nodes"></a> [talos\_nodes](#output\_talos\_nodes) | Map of Talos node addresses to their roles, versions, images, endpoints, upgrade settings, and lifecycle settings. |
| <a name="output_talos_version"></a> [talos\_version](#output\_talos\_version) | Talos version contract used to generate compatible machine secrets and configurations. |
| <a name="output_talosconfig"></a> [talosconfig](#output\_talosconfig) | Sensitive Talos client configuration scoped to the cluster nodes and control plane endpoints. |
| <a name="output_worker_nodes"></a> [worker\_nodes](#output\_worker\_nodes) | Set of addresses for Talos worker nodes. |
<!-- markdownlint-enable -->
<!-- END_TF_DOCS -->
