########################################
# Storage Module (Cloud Storage Bucket)
########################################
module "storage" {
  source      = "./modules/storage"
  bucket_name = var.bucket_name
  region      = var.region
}

########################################
# Service Account + IAM Module
########################################
module "service_account" {
  source      = "./modules/service-account"
  account_id  = "tf-vm-log-uploader"
  bucket_name = module.storage.bucket_name
}
