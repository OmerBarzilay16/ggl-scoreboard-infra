data "google_service_account" "arena_builder" {
  account_id = "arena-builder-sa"
  project    = var.project_id
}

data "google_service_account" "scoreboard_deployer" {
  account_id = "scoreboard-deployer-sa"
  project    = var.project_id
}
