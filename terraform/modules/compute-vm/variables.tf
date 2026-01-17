variable "vm_name" {
  description = "Name of the Compute Engine VM"
  type        = string
}

variable "zone" {
  description = "GCP zone"
  type        = string
}

variable "service_account_email" {
  description = "Service account email for the VM"
  type        = string
}

variable "bucket_name" {
  description = "Cloud Storage bucket name for logs"
  type        = string
}
