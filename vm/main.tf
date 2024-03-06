resource "google_compute_instance" "default" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone        = var.zone

  tags = var.tags

  boot_disk {
    initialize_params {
      image = var.instance_image
      labels = local.labels
    }
  }
  network_interface {
    network = var.network
    access_config {
      network_tier = "PREMIUM"
    }
  }
  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }

}
