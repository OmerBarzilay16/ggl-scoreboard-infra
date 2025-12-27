output "arena_builder_sa_email" {
  value = google_service_account.arena_builder.email
}

output "scoreboard_deployer_sa_email" {
  value = google_service_account.scoreboard_deployer.email
}

output "workload_identity_pool_name" {
  # full resource name: projects/<num>/locations/global/workloadIdentityPools/<id>
  value = google_iam_workload_identity_pool.github.name
}

output "wif_provider_resource_name" {
  # full resource name used by google-github-actions/auth: projects/<num>/locations/global/workloadIdentityPools/<id>/providers/<id>
  value = google_iam_workload_identity_pool_provider.github.name
}
