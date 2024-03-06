variable "label_definitions" {
  type = map(string)
  description = "The labels for the compute instance"
  default = {
    key1 = "value1"
    key2 = "value2"
    # Add other default labels here if needed
  }
}

variable "instance_name" {
  type    = string
  description = "The name of the compute instance"
  default     = "myinstance"
}

variable "machine_type" {
  type    = string
  description = "The machine type for the compute instance"
  default     = "n1-standard-1"
}

variable "zone" {
  type    = string
  description = "The region where the compute instance will be created"
  default     = "us-central1-a"
}

variable "tags" {
  type    = list(string)
  description = "The list of tags for the compute instance"
  default     = ["deafult","from-default"]
}

variable "instance_image" {
  type    = string
  description = "The image for the boot disk of the compute instance"
  default     = "ubuntu-2204-jammy-v20240208"
}
variable "network" {
  type        = string
  description = "The network for the network interface"
  default = "default"
}

variable "service_account_email" {
  type        = string
  description = "The email address of the service account"

  default = "terraform@devops-practice-411411.iam.gserviceaccount.com"
}

