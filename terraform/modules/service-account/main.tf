resource "google_service_account" "this" {
  account_id   = var.account_id
  display_name = "Terraform VM Log Uploader Service Account"
}

resource "google_storage_bucket_iam_member" "writer" {
  bucket = var.bucket_name
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${google_service_account.this.email}"
}

resource "google_storage_bucket_iam_member" "reader" {
  bucket = var.bucket_name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.this.email}"
}