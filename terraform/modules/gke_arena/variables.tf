variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "zones" {
  type        = list(string)
  description = "Two zones in the region."
}

variable "cluster_name" {
  type = string
}

variable "network_name" {
  type = string
}

variable "subnet_cidr" {
  type = string
}

variable "pods_cidr" {
  type = string
}

variable "services_cidr" {
  type = string
}
