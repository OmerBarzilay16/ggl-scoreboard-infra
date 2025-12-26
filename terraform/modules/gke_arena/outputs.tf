output "cluster_name" {
  value = google_container_cluster.arena.name
}

output "region" {
  value = google_container_cluster.arena.location
}

output "endpoint" {
  value = google_container_cluster.arena.endpoint
}

output "ca_certificate" {
  value = google_container_cluster.arena.master_auth[0].cluster_ca_certificate
}

output "workload_pool" {
  value = google_container_cluster.arena.workload_identity_config[0].workload_pool
}

output "workload_identity_annotation_example" {
  value       = "iam.gke.io/gcp-service-account=<GSA_NAME>@${var.project_id}.iam.gserviceaccount.com"
  description = "Annotation you would place on a Kubernetes ServiceAccount to use Workload Identity."
}
