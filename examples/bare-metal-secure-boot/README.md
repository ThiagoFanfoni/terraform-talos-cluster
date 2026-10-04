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

<!-- BEGIN_TF_DOCS -->
<!-- markdownlint-disable -->


## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_base_image"></a> [base\_image](#module\_base\_image) | ../base-image/ | n/a |
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
