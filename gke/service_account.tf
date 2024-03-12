resource "random_string" "cluster_service_account_suffix" {
  upper   = false
  lower   = true
  special = false
  length  = 4
}

resource "google_service_account" "cluster_service_account" {
  count        = local.create_service_account
  project      = var.project_id
  account_id   = "sa-gke-${local.service_account_name}"
  display_name = "Terraform-managed service account for cluster ${var.cluster_name}"
}

resource "google_project_iam_member" "cluster_service_account-log_writer" {
  count   = local.create_service_account
  project = google_service_account.cluster_service_account[0].project
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${local.service_account}"
}

resource "google_project_iam_member" "cluster_service_account-metric_writer" {
  count   = local.create_service_account
  project = google_project_iam_member.cluster_service_account-log_writer[0].project
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${local.service_account}"
}

resource "google_project_iam_member" "cluster_service_account-monitoring_viewer" {
  count   = local.create_service_account
  project = google_project_iam_member.cluster_service_account-metric_writer[0].project
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${local.service_account}"
}

resource "google_project_iam_member" "cluster_service_account-resourceMetadata-writer" {
  count   = local.create_service_account
  project = google_project_iam_member.cluster_service_account-monitoring_viewer[0].project
  role    = "roles/stackdriver.resourceMetadata.writer"
  member  = "serviceAccount:${local.service_account}"
}

resource "google_project_iam_member" "cluster_service_account-storage-objectAdmin" {
  count   = local.create_service_account
  project = google_project_iam_member.cluster_service_account-resourceMetadata-writer[0].project
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${local.service_account}"
}

# resource "google_service_account" "additional_service_accounts" {
#   for_each     = local.additional_service_accounts
#   project      = var.project_id
#   account_id   = each.key
#   display_name = "Terraform-managed service account for cluster ${var.cluster_name}"
# }

# resource "google_service_account_key" "additional_service_account_keys" {
#   for_each           = local.additional_service_accounts
#   service_account_id = google_service_account.additional_service_accounts[each.key].name
# }

# resource "google_project_iam_member" "additional_service_accounts-k8s-viewer" {
#   for_each = local.additional_service_accounts
#   project  = var.project_id
#   role     = "roles/container.viewer"
#   member   = "serviceAccount:${google_service_account.additional_service_accounts[each.key].email}"
# }