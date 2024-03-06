resource "google_compute_instance_template" "instance_template" {
  name_prefix    = var.instance_template_name_prefix
  machine_type   = var.machine_type
  region         = var.region
  can_ip_forward = var.can_ip_forward

  // boot disk
  disk {
    source_image = var.template_source_image
    auto_delete  = var.disk_auto_delete
    boot         = var.boot
    disk_type    = var.disk_type
    disk_size_gb = var.disk_size_gb
    labels       = var.labels
  }

  // networking
  network_interface {
    network = var.network
    subnetwork = var.subnetwork
  }
  scheduling {
    on_host_maintenance = var.on_host_maintenance
    automatic_restart = var.automatic_restart
  }
  

  lifecycle {
    create_before_destroy = true
  }
  metadata_startup_script = file(var.startup_script_file)
}
