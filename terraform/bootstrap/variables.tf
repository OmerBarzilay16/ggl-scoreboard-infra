variable "project_id" {
  description = "GCP project id."
  type        = string
}

variable "github_owner" {
  description = "GitHub org/user that owns the repository (case-sensitive)."
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name (case-sensitive)."
  type        = string
}
