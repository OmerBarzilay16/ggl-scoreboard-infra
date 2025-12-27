variable "project_id" {
  type        = string
  description = "GCP project id."
}

variable "region" {
  type        = string
  description = "GCP region for the regional GKE cluster."
  default     = "us-central1"
}

variable "zones" {
  type        = list(string)
  description = "Two distinct zones in the same region."
  default     = ["us-central1-a", "us-central1-b"]
}

variable "cluster_name" {
  type    = string
  default = "ggl-arena"
}

variable "network_name" {
  type    = string
  default = "ggl-vpc"
}

variable "subnet_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "pods_cidr" {
  type    = string
  default = "10.20.0.0/16"
}

variable "services_cidr" {
  type    = string
  default = "10.30.0.0/20"
}

# GitHub repo that is allowed to authenticate via OIDC to GCP (WIF)
variable "github_owner" {
  type        = string
  description = "GitHub org/user that owns the repo (e.g. omerbarzolay16)."
}

variable "github_repo" {
  type        = string
  description = "GitHub repository name (e.g. ggl-scoreboard)."
}
