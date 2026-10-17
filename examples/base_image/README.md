# Base-image module

This shared module generates Talos Linux images for the other
examples. It creates a Talos Image Factory schematic with firmware and microcode
extensions compatible with the requested Talos version and exposes image URLs
through its outputs.

Use the same `talos_version` for this module and the cluster configuration:

```hcl
module "base_image" {
  source        = "../base-image"
  talos_version = local.talos_version
}
```

Choose the image output appropriate for your example. For Secure Boot, use
`module.base_image.secure_boot` as the installer image in the node configuration
and installation patches. See the
[bare-metal Secure Boot example](../bare-metal-secure-boot/README.md) for a complete
configuration.

<!-- BEGIN_TF_DOCS -->
<!-- markdownlint-disable -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_talos"></a> [talos](#requirement\_talos) | ~> 0.12.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_talos"></a> [talos](#provider\_talos) | 0.12.0 |

## Resources

| Name | Type |
| ---- | ---- |
| [talos_image_factory_schematic.this](https://registry.terraform.io/providers/siderolabs/talos/latest/docs/resources/image_factory_schematic) | resource |
| [talos_image_factory_extensions_versions.this](https://registry.terraform.io/providers/siderolabs/talos/latest/docs/data-sources/image_factory_extensions_versions) | data source |
| [talos_image_factory_urls.this](https://registry.terraform.io/providers/siderolabs/talos/latest/docs/data-sources/image_factory_urls) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_talos_version"></a> [talos\_version](#input\_talos\_version) | Talos Version | `string` | `"v1.14.2"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_secure_boot"></a> [secure\_boot](#output\_secure\_boot) | secureboot image |
<!-- markdownlint-enable -->
<!-- END_TF_DOCS -->
