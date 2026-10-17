# Resolve extension versions that are compatible with the selected Talos
# version before creating the Image Factory schematic.

terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "~> 0.12.0"
    }
  }
}

variable "talos_version" {
  type        = string
  description = "Talos Version"
  default     = "v1.14.2"
}

data "talos_image_factory_extensions_versions" "this" {
  talos_version = var.talos_version
  filters = {
    names = [
      "amd-ucode",
      "amdgpu",
      "i915",
      "intel-ucode",
      "realtek-firmware"
    ]
  }
}

# Build a schematic containing the firmware and microcode required by the
# machines in this example.
resource "talos_image_factory_schematic" "this" {
  schematic = yamlencode({
    customization = {
      systemExtensions = {
        officialExtensions = [
          for i in data.talos_image_factory_extensions_versions.this.extensions_info : i.name
        ]
      }
    }
  })
}

# Obtain the metal installer and boot-media URLs for the generated schematic.
data "talos_image_factory_urls" "this" {
  talos_version = var.talos_version
  schematic_id  = talos_image_factory_schematic.this.id
  platform      = "metal"
}

output "secure_boot" {
  description = "secureboot image"
  value       = data.talos_image_factory_urls.this.urls.installer_secureboot
}
