resource "random_id" "suffix" {
  byte_length = 4
}

locals {
  bucket_name = var.state_bucket_name != "" ? var.state_bucket_name : "${var.project_id}-tfstate-${random_id.suffix.hex}"
}

resource "google_storage_bucket" "tfstate" {
  name                        = local.bucket_name
  location                    = var.region
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
  lifecycle_rule {
    condition {
      num_newer_versions = 5
    }
    action {
      type = "Delete"
    }
  }
}

output "state_bucket_name" {
  value       = google_storage_bucket.tfstate.name
  description = "Use this bucket as the Terraform backend bucket for terraform/envs/prod."
}
