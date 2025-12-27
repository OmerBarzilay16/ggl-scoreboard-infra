module "gke_arena" {
  source = "../../modules/gke_arena"

  project_id   = var.project_id
  region       = var.region
  zones        = var.zones
  cluster_name = var.cluster_name

  network_name  = var.network_name
  subnet_cidr   = var.subnet_cidr
  pods_cidr     = var.pods_cidr
  services_cidr = var.services_cidr
}
