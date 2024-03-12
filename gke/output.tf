output "name" {
  description = "Cluster name"
  value       = local.cluster_name
}

output "type" {
  description = "Cluster type (regional / zonal)"
  value       = local.cluster_type
}

output "location" {
  description = "Cluster location (region if regional cluster, zone if zonal cluster)"
  value       = local.cluster_location
}

output "region" {
  description = "Cluster region"
  value       = local.cluster_region
}

output "zones" {
  description = "List of zones in which the cluster resides"
  value       = local.cluster_zones
}

output "endpoint" {
  sensitive   = true
  description = "Cluster endpoint"
  value       = local.cluster_endpoint
  depends_on = [
    google_container_cluster.cluster,
    google_container_node_pool.node_pools
  ]
}

output "k8s_version" {
  description = "Minimum master kubernetes version"
  value       = google_container_cluster.cluster.min_master_version
}

output "logging_service" {
  description = "Logging service used"
  value       = local.cluster_logging_service
}

output "monitoring_service" {
  description = "Monitoring service used"
  value       = local.cluster_monitoring_service
}

output "master_authorized_networks_config" {
  description = "Networks from which access to master is permitted"
  value       = google_container_cluster.cluster.master_authorized_networks_config
}

output "ca_certificate" {
  sensitive   = true
  description = "Cluster ca certificate (base64 encoded)"
  value       = local.cluster_ca_certificate
}

output "network_policy_enabled" {
  description = "Whether network policy enabled"
  value       = local.cluster_network_policy_enabled
}

output "http_load_balancing_enabled" {
  description = "Whether http load balancing enabled"
  value       = local.cluster_http_load_balancing_enabled
}

output "horizontal_pod_autoscaling_enabled" {
  description = "Whether horizontal pod autoscaling enabled"
  value       = local.cluster_horizontal_pod_autoscaling_enabled
}

output "node_pools_names" {
  description = "List of node pools names"
  value       = local.cluster_node_pools_names
}

output "node_pools_versions" {
  description = "List of node pools versions"
  value       = local.cluster_node_pools_versions
}

output "service_account" {
  description = "The service account to default running nodes as if not overridden in `node_pools`."
  value       = local.service_account
}

output "master_ipv4_cidr_block" {
  description = "The IP range in CIDR notation used for the hosted master network"
  value       = var.master_ipv4_cidr_block
}

output "peering_name" {
  description = "The name of the peering between this cluster and the Google owned VPC."
  value       = local.cluster_peering_name
}

# output "additional_service_accounts" {
#   description = "List of additional Service Accounts"
#   sensitive   = true
#   value = [
#     for sa in local.additional_service_accounts : {
#       "account" : sa
#       "email" : google_service_account.additional_service_accounts[sa].email
#       "access_key" : google_service_account_key.additional_service_account_keys[sa].private_key
#     }
#   ]
# }

output "cluster_info" {
  description = "cluster information"
  value       = google_container_cluster.cluster
}