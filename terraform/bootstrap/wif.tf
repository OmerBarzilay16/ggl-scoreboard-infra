# Workload Identity Federation (GitHub OIDC -> GCP)
# Creates the pool/provider that later workflows will use (keyless)

resource "google_iam_workload_identity_pool" "github" {
  workload_identity_pool_id = "github-pool"
  display_name              = "GitHub Actions Pool"
  description               = "OIDC identities from GitHub Actions."
}

resource "google_iam_workload_identity_pool_provider" "github" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  display_name                       = "GitHub OIDC Provider"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
    "attribute.actor"      = "assertion.actor"
    "attribute.ref"        = "assertion.ref"
  }

  # Restrict who can use this provider:
  attribute_condition = "attribute.repository == '${var.github_owner}/${var.github_repo}'"
}

# Allow GitHub repo to impersonate the Builder SA
resource "google_service_account_iam_member" "wif_impersonate_builder" {
  service_account_id = google_service_account.arena_builder.name
  role               = "roles/iam.workloadIdentityUser"

  member = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/${var.github_owner}/${var.github_repo}"
}

# Allow GitHub repo to impersonate the Deployer SA
resource "google_service_account_iam_member" "wif_impersonate_deployer" {
  service_account_id = google_service_account.scoreboard_deployer.name
  role               = "roles/iam.workloadIdentityUser"

  member = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/${var.github_owner}/${var.github_repo}"
}
