resource "random_shuffle" "available_zones" {
  input        = data.google_compute_zones.available_zones.names
  result_count = 3
}

locals {
  network_project_id = var.network_project_id != "" ? var.network_project_id : var.project_id
  network            = "projects/${local.network_project_id}/global/networks/${var.network}"
  subnetwork         = "projects/${local.network_project_id}/regions/${var.region}/subnetworks/${var.subnetwork}"

  location = var.regional ? var.region : var.zones[0]
  region   = var.regional ? var.region : join("-", slice(split("-", var.zones[0]), 0, 2))

  default_auto_upgrade = var.regional ? var.auto_upgrade : false

  node_locations = var.regional ? coalescelist(compact(var.zones), sort(random_shuffle.available_zones.result)) : slice(var.zones, 1, length(var.zones))

  master_authorized_networks_config = length(var.master_authorized_networks) == 0 ? [] : [{
    cidr_blocks : var.master_authorized_networks
  }]

  workload_identity_enabled = !(var.identity_namespace == null || var.identity_namespace == "null")
  cluster_workload_identity_config = !local.workload_identity_enabled ? [] : var.identity_namespace == "enabled" ? [{
    workload_pool = "${var.project_id}.svc.id.goog" }] : [{ workload_pool = var.identity_namespace
  }]



  cluster_network_policy = var.network_policy ? [{
    enabled  = true
    provider = var.network_policy_provider
    }] : [{
    enabled  = false
    provider = null
  }]

  node_pool_names = [for np in toset(var.node_pools) : np.name]
  node_pools      = zipmap(local.node_pool_names, tolist(toset(var.node_pools)))

  node_pools_labels = merge(
    { all = {} },
    { default-node-pool = {} },
    zipmap(
      [for node_pool in var.node_pools : node_pool["name"]],
      [for node_pool in var.node_pools : {}]
    ),
    var.node_pools_labels
  )

  node_pools_metadata = merge(
    { all = {} },
    { default-node-pool = {} },
    zipmap(
      [for node_pool in var.node_pools : node_pool["name"]],
      [for node_pool in var.node_pools : {}]
    ),
    var.node_pools_metadata
  )

  node_pools_taints = merge(
    { all = [] },
    { default-node-pool = [] },
    zipmap(
      [for node_pool in var.node_pools : node_pool["name"]],
      [for node_pool in var.node_pools : []]
    ),
    var.node_pools_taints
  )

  node_pools_tags = merge(
    { all = [] },
    { default-node-pool = [] },
    zipmap(
      [for node_pool in var.node_pools : node_pool["name"]],
      [for node_pool in var.node_pools : []]
    ),
    var.node_pools_tags
  )

  node_pools_oauth_scopes = merge(
    { all = ["https://www.googleapis.com/auth/cloud-platform"] },
    { default-node-pool = [] },
    zipmap(
      [for node_pool in var.node_pools : node_pool["name"]],
      [for node_pool in var.node_pools : []]
    ),
    var.node_pools_oauth_scopes
  )

  create_service_account = var.service_account == "" ? 1 : 0

  service_account_list = compact(
    concat(
      google_service_account.cluster_service_account.*.email,
      ["dummy"],
    ),
  )

  enable_vertical_pod_autoscaling = var.regional ? var.vertical_pod_autoscaling : false

  service_account      = local.create_service_account == 1 ? local.service_account_list[0] : var.service_account
  service_account_name = substr(local.cluster_name, 0, min(20, length(local.cluster_name)))

  # using set for future enhancement in case we need more than these two service accounts
  #additional_service_accounts = toset(["readonly-${local.service_account_name}", "deployer-${local.service_account_name}"])

  name_prefix                     = "${lower(var.environment)}-${lower(var.app_prefix)}"
  cluster_name                    = "${local.name_prefix}-${lower(var.cluster_name)}"
  cluster_network_tag             = "gke-${local.cluster_name}"
  cluster_type                    = var.regional ? "regional" : "zonal"
  cluster_location                = google_container_cluster.cluster.location
  cluster_region                  = var.regional ? var.region : join("-", slice(split("-", local.cluster_location), 0, 2))
  cluster_zones                   = sort(google_container_cluster.cluster.node_locations)
  cluster_endpoint                = google_container_cluster.cluster.private_cluster_config.0.private_endpoint
  cluster_logging_service         = google_container_cluster.cluster.logging_service
  cluster_monitoring_service      = google_container_cluster.cluster.monitoring_service
  cluster_master_auth             = concat(google_container_cluster.cluster.*.master_auth, [])
  cluster_master_auth_list_layer1 = local.cluster_master_auth
  cluster_master_auth_list_layer2 = local.cluster_master_auth_list_layer1[0]
  cluster_master_auth_map         = local.cluster_master_auth_list_layer2[0]
  cluster_ca_certificate          = local.cluster_master_auth_map["cluster_ca_certificate"]
  cluster_node_pools_names        = concat([for np in google_container_node_pool.node_pools : np.name], [""])
  cluster_node_pools_versions     = concat([for np in google_container_node_pool.node_pools : np.version], [""])
  cluster_peering_name            = google_container_cluster.cluster.private_cluster_config.0.peering_name

  cluster_network_policy_enabled             = !google_container_cluster.cluster.addons_config.0.network_policy_config.0.disabled
  cluster_http_load_balancing_enabled        = !google_container_cluster.cluster.addons_config.0.http_load_balancing.0.disabled
  cluster_horizontal_pod_autoscaling_enabled = !google_container_cluster.cluster.addons_config.0.horizontal_pod_autoscaling.0.disabled
}