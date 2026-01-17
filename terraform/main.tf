########################################
# Cloud Storage Bucket for VM Logs
#################################
module "storage" {
  source      = "./modules/storage"
  bucket_name = var.bucket_name
  region      = var.region
}

########################################
# Service Account for VM Log Upload
########################################
resource "google_service_account" "vm_sa" {
  account_id   = "tf-vm-log-uploader"
  display_name = "Terraform VM Log Uploader Service Account"
}

########################################
# IAM: Allow Service Account to Upload Logs
########################################
resource "google_storage_bucket_iam_member" "vm_sa_writer" {
  bucket = google_storage_bucket.vm_logs.name
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${google_service_account.vm_sa.email}"
}

resource "google_storage_bucket_iam_member" "vm_sa_reader" {
  bucket = google_storage_bucket.vm_logs.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.vm_sa.email}"
}