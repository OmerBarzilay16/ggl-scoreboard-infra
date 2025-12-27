# Workload Identity Federation (GitHub OIDC -> GCP)
# References the WIF pool/provider created by bootstrap terraform.
# This allows GitHub Actions to impersonate the two SAs WITHOUT storing JSON keys.

# Reference the bootstrap-created WIF pool
data "google_iam_workload_identity_pool" "github" {
  project                   = var.project_id
  workload_identity_pool_id = "github-pool-ggl2"
}

data "google_iam_workload_identity_pool_provider" "github" {
  project                            = var.project_id
  workload_identity_pool_id          = data.google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider-ggl2"
}