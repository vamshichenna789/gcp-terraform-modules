data "google_compute_zones" "available_zones" {
  project = var.project_id
  region  = local.region
}