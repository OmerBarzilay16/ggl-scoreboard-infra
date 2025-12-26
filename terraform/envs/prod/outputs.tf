output "cluster_name" {
  value = module.gke_arena.cluster_name
}

output "cluster_region" {
  value = module.gke_arena.region
}

output "workload_identity_pool" {
  value       = module.gke_arena.workload_pool
  description = "GKE Workload Identity pool used for Kubernetes pods."
}

output "arena_builder_sa_email" {
  value = google_service_account.arena_builder.email
}

output "scoreboard_deployer_sa_email" {
  value = google_service_account.scoreboard_deployer.email
}

output "wif_provider_resource_name" {
  value       = google_iam_workload_identity_pool_provider.github.name
  description = "Use this in GitHub Actions auth step as workload_identity_provider."
}
