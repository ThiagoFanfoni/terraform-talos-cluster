variable "cluster_endpoint" {
  type        = string
  description = "Kubernetes API endpoint URL advertised in the generated Talos machine configurations."

  validation {
    condition     = can(regex("^https://[^[:space:]]+$", var.cluster_endpoint))
    error_message = "The cluster endpoint must be a nonempty HTTPS URL."
  }
}

variable "cluster_name" {
  type        = string
  description = "Name assigned to the Talos Kubernetes cluster."

  validation {
    condition     = trimspace(var.cluster_name) != ""
    error_message = "The cluster name must not be empty."
  }
}

variable "include_machine_configuration_docs" {
  type        = bool
  description = "Includes field documentation in the generated Talos machine configurations when enabled."
  default     = false
}

variable "include_machine_configuration_examples" {
  type        = bool
  description = "Includes configuration examples in the generated Talos machine configurations when enabled."
  default     = false
}

variable "nodes" {
  type = set(object({
    # YAML patches merged into the generated Talos machine configuration.
    config_patches = optional(list(string))

    # Drains Kubernetes workloads before upgrading Kubernetes when enabled.
    drain_on_upgrade = optional(bool, false)

    # Talos API endpoint used by the provider to connect to the node.
    endpoint = optional(string)

    # Ignores Kubernetes version drift instead of upgrading the node when enabled.
    ignore_kubernetes_upgrade_drift = optional(bool)

    # Talos installer image used for installation and Talos upgrades.
    image = optional(string)

    # Talos machine role. Supported values are "controlplane" and "worker".
    machine_type = string

    # Node address and unique identifier within the module.
    node = string

    # Reboot mode used when an operation requires the node to restart.
    reboot_mode = optional(string)

    # Actions performed when the node resource is destroyed.
    on_destroy = optional(object({
      # Performs the destroy operation gracefully when enabled.
      graceful = optional(bool, true)

      # Reboots the machine after the destroy operation when enabled.
      reboot = optional(bool, true)

      # Resets the Talos machine during destruction when enabled.
      reset = optional(bool, true)
    }), {})
  }))
  description = "Set of Talos nodes to configure, including their roles, addresses, images, patches, upgrade behavior, and destroy behavior."

  validation {
    condition     = alltrue([for i in var.nodes : contains(["controlplane", "worker"], i.machine_type)])
    error_message = "Each node machine type must be either \"controlplane\" or \"worker\"."
  }

  validation {
    condition     = alltrue([for i in var.nodes : trimspace(i.node) != ""])
    error_message = "Each node address must not be empty."
  }

  validation {
    condition     = length(var.nodes) == length(distinct([for i in var.nodes : i.node]))
    error_message = "Each node address must be unique."
  }

  validation {
    condition = alltrue([
      for i in var.nodes : i.endpoint == null ? true : trimspace(i.endpoint) != ""
    ])
    error_message = "A configured node endpoint must not be empty."
  }

  validation {
    condition = alltrue([
      for i in var.nodes : i.image == null ? true : trimspace(i.image) != ""
    ])
    error_message = "A configured Talos installer image must not be empty."
  }

  validation {
    condition = alltrue([
      for i in var.nodes : i.config_patches == null ? true : alltrue([
        for v in i.config_patches : trimspace(v) != ""
      ])
    ])
    error_message = "Configured machine patches must not be empty."
  }

  validation {
    condition = alltrue([
      for i in var.nodes : i.reboot_mode == null ? true : contains(["DEFAULT", "POWERCYCLE"], i.reboot_mode)
    ])
    error_message = "A configured reboot mode must be either \"DEFAULT\" or \"POWERCYCLE\"."
  }

  validation {
    condition = length([
      for i in var.nodes : i
      if i.machine_type == "controlplane"
    ]) % 2 == 1
    error_message = "The cluster must contain an odd number of control-plane nodes."
  }
}

variable "talos_version" {
  type        = string
  description = "Talos version contract used to generate compatible machine secrets and configurations. Example values include `v1.12`, `v1.12.1`, `1.12`, and `1.12.1`."
  default     = null

  validation {
    condition = var.talos_version == null ? true : can(regex(
      "^v?[0-9]+[.][0-9]+([.][0-9]+)?(-[0-9A-Za-z.-]+)?([+][0-9A-Za-z.-]+)?$",
      var.talos_version,
    ))
    error_message = "The Talos version must use a major.minor or major.minor.patch format, optionally prefixed with \"v\" and followed by prerelease or build metadata."
  }
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version applied through the generated Talos machine configurations and managed node upgrades."
  default     = null

  validation {
    condition = var.kubernetes_version == null ? true : can(regex(
      "^v?[0-9]+[.][0-9]+[.][0-9]+(-[0-9A-Za-z.-]+)?([+][0-9A-Za-z.-]+)?$",
      var.kubernetes_version,
    ))
    error_message = "The Kubernetes version must use a major.minor.patch format, optionally prefixed with \"v\" and followed by prerelease or build metadata."
  }
}
