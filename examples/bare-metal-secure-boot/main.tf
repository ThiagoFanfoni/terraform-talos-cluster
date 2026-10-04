locals {
  talos_version      = "v1.14.2"
  kubernetes_version = "v1.37.1"
  cluster_name       = "example"

  config_patches = tolist([
    templatefile("${path.module}/config_patches/install.yaml", { image = module.base_image.secure_boot }),
    file("${path.module}/config_patches/disk_encryption.yaml"),
    file("${path.module}/config_patches/ntp.yaml")
  ])
}

module "base_image" {
  source        = "../base-image/"
  talos_version = local.talos_version
}

module "example" {
  source = "../.."

  cluster_endpoint   = "https://192.168.65.10:6443"
  cluster_name       = local.cluster_name
  talos_version      = local.talos_version
  kubernetes_version = local.kubernetes_version

  nodes = [
    {
      config_patches = local.config_patches
      image          = module.base_image.secure_boot
      machine_type   = "controlplane"
      node           = "192.168.65.10"

      on_destroy = {
        # Skip graceful Kubernetes operations when resetting the lab cluster.
        graceful = false
      }
    },
    {
      config_patches = local.config_patches
      image          = module.base_image.secure_boot
      machine_type   = "worker"
      node           = "192.168.65.12"
    },
    {
      config_patches = local.config_patches
      image          = module.base_image.secure_boot
      machine_type   = "worker"
      node           = "192.168.65.14"
    },
    {
      config_patches = local.config_patches
      image          = module.base_image.secure_boot
      machine_type   = "worker"
      node           = "192.168.65.16"
    }
  ]
}
