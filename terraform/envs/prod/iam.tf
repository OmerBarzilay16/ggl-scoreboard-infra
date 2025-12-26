locals {
  arena_builder_sa_name   = "arena-builder-sa"
  deployer_sa_name        = "scoreboard-deployer-sa"
}

resource "google_service_account" "arena_builder" {
  account_id   = local.arena_builder_sa_name
  display_name = "Arena Builder SA (Terraform)"
}

resource "google_service_account" "scoreboard_deployer" {
  account_id   = local.deployer_sa_name
  display_name = "Scoreboard Deployer SA (kubectl)"
}

# === Builder SA permissions (broad enough to provision/destroy infra for this assignment) ===
resource "google_project_iam_member" "builder_roles" {
  for_each = toset([
    "roles/container.admin",
    "roles/compute.admin",
    "roles/iam.serviceAccountAdmin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/storage.admin",
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.arena_builder.email}"
}

# === Deployer SA permissions (minimal for interacting with GKE + reading cluster info) ===
resource "google_project_iam_member" "deployer_roles" {
  for_each = toset([
    "roles/container.clusterViewer",
    "roles/container.developer",
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.scoreboard_deployer.email}"
}
