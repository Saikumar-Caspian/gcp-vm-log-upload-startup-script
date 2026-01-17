resource "google_storage_bucket" "this" {
  name     = var.bucket_name
  location = var.region

  uniform_bucket_level_access = true
}
