terraform {
  required_version = ">= 1.16"

  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "~> 0.12.0"
    }
  }
}
