variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "bucket_name" {
  description = "Cloud Storage bucket name for VM logs"
  type        = string
}

variable "vm_name" {
  description = "Name of the Compute Engine VM"
  type        = string
  default     = "tf-log-uploader-vm"
}