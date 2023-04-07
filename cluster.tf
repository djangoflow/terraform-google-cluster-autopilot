data "google_client_config" "google" {}

resource "google_container_cluster" "cluster" {
  name                  = var.name
  network               = var.network
  location              = var.location
  enable_autopilot      = true

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = var.cluster_ipv4_cidr_block
    services_ipv4_cidr_block = var.services_ipv4_cidr_block
  }

  binary_authorization {
    evaluation_mode = "DISABLED"
  }

  default_snat_status {
    disabled = false
  }

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.authorized_networks
      iterator = cidr
      content {
        cidr_block   = cidr.value
        display_name = cidr.key
      }
    }
  }

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }
}
