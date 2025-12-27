# Workload Identity Federation (GitHub OIDC -> GCP)
# References the WIF pool/provider created by bootstrap terraform.
# This allows GitHub Actions to impersonate the two SAs WITHOUT storing JSON keys.

# Reference the bootstrap-created WIF pool
data "google_iam_workload_identity_pool" "github" {
  workload_identity_pool_id = "github-pool-ggl2"
  location                  = "global"
  project                   = var.project_id
}

# Reference the bootstrap-created WIF provider
data "google_iam_workload_identity_pool_provider" "github" {
  workload_identity_pool_id          = data.google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider-ggl2"
  location                           = "global"
  project                            = var.project_id
}

# Allow GitHub repo to impersonate the Builder SA
resource "google_service_account_iam_member" "wif_impersonate_builder" {
  service_account_id = google_service_account.arena_builder.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${data.google_iam_workload_identity_pool.github.name}/attribute.repository/${var.github_owner}/${var.github_repo}"
}

# Allow GitHub repo to impersonate the Deployer SA
resource "google_service_account_iam_member" "wif_impersonate_deployer" {
  service_account_id = google_service_account.scoreboard_deployer.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${data.google_iam_workload_identity_pool.github.name}/attribute.repository/${var.github_owner}/${var.github_repo}"
}
