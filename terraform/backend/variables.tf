variable "project_id" {
  type        = string
  description = "GCP project id."
}

variable "region" {
  type        = string
  description = "Default region."
  default     = "us-central1"
}

variable "state_bucket_name" {
  type        = string
  description = "Optional explicit bucket name. If empty, a unique name is generated."
  default     = ""
}
