resource "google_container_node_pool" "primary" {
  provider = google-beta

  name       = "${var.cluster_name}-np"
  location   = var.region
  cluster    = google_container_cluster.arena.name
  node_count = 1

  node_locations = var.zones

  autoscaling {
    min_node_count = 1
    max_node_count = 1
  }

  node_config {
    machine_type = "e2-small"
    spot         = true

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }

    labels = {
      workload = "scoreboard"
    }

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}
