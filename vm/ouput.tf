output "internal_ip" {
  description = "Internal IP address of the created VM"
  value       = google_compute_instance.default.network_interface[0].network_ip
}

output "external_ip" {
  description = "External IP address of the created VM"
  value       = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
}

