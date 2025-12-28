resource "google_compute_network" "vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.network_name}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.subnet_cidr

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = var.pods_cidr
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = var.services_cidr
  }
}

resource "google_container_cluster" "arena" {
  provider = google-beta

  name                = var.cluster_name
  location            = var.region
  deletion_protection = false

  node_locations = var.zones

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  release_channel {
    channel = "REGULAR"
  }

  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }

  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS"]
  }
}

resource "google_container_node_pool" "primary" {
  provider = google-beta

  name     = "${var.cluster_name}-np"
  location = var.region
  cluster  = google_container_cluster.arena.name

  node_locations = var.zones

  # Regional node pools: node_count is PER ZONE.
  # With 2 zones -> node_count=1 => total 2 nodes (HA).
  node_count = 1

  autoscaling {
    # Also PER ZONE:
    # With 2 zones -> min=1 => total min 2 nodes
    # With 2 zones -> max=1 => total max 2 nodes (fixed size, predictable HA)
    min_node_count = 1
    max_node_count = 1
  }

  node_config {
    machine_type = "e2-medium"

    # Keep stable nodes (avoid spot evictions)
    spot = false

    # IMPORTANT: avoid SSD_TOTAL_GB quota hits
    disk_type    = "pd-standard"
    disk_size_gb = 20

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
