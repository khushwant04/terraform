variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "GCP region"
}

variable "zone" {
  type        = string
  default     = "us-central1-a"
  description = "GCP zone"
}

variable "vm_name" {
  type        = string
  default     = "terraform-vm"
  description = "Name of the VM"
}

variable "machine_type" {
  type        = string
  default     = "e2-micro"
  description = "GCP machine type"
}

variable "boot_image" {
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2204-lts"
  description = "Boot disk image"
}
