terraform {
  required_version = ">= 1.5.0"

  backend "gcs" {
    # IMPORTANT:
    # You must pass the bucket name at init-time, e.g.:
    # terraform init -backend-config="bucket=<STATE_BUCKET_NAME>"
    prefix = "ggl/prod"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.30.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 5.30.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.30.0"
    }
  }
}
