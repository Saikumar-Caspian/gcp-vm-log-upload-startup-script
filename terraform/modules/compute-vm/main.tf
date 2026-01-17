resource "google_compute_instance" "this" {
  name         = var.vm_name
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  service_account {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }

  metadata_startup_script = templatefile(
    "${path.module}/startup.sh",
    {
      bucket_name = var.bucket_name
    }
  )

  tags = ["tf-log-uploader"]
}
