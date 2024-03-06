variable "network_name" {
  description = "The name of the network where subnets will be created"
  type        = string
}
variable "auto_create_subnetworks" {
  description = "Specifies whether to create default subnetworks in this VPC network"
  type        = bool
}

variable "routing_mode" {
  description = "The network routing mode (GLOBAL or REGIONAL)"
  type        = string
}

variable "network_description" {
  description = "The description of the VPC network"
  type        = string
}

variable "subnets" {
  type = list(object({
    subnet_name                      = string
    subnet_ip                        = string
    subnet_region                    = string
    subnet_private_access            = optional(string, "false")
    subnet_private_ipv6_access       = optional(string)
    subnet_flow_logs                 = optional(string, "false")
    subnet_flow_logs_interval        = optional(string, "INTERVAL_5_SEC")
    subnet_flow_logs_sampling        = optional(string, "0.5")
    subnet_flow_logs_metadata        = optional(string, "INCLUDE_ALL_METADATA")
    subnet_flow_logs_filter          = optional(string, "true")
    subnet_flow_logs_metadata_fields = optional(list(string), [])
    description                      = optional(string)
    purpose                          = optional(string)
    role                             = optional(string)
    stack_type                       = optional(string)
    ipv6_access_type                 = optional(string)
  }))
  description = "The list of subnets being created"
}

variable "secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used in some of the subnets"
  default     = {}
}


