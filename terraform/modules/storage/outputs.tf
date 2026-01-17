output "bucket_name" {
  description = "Name of the created Cloud Storage bucket"
  value       = google_storage_bucket.this.name
}
