terraform {
  required_version = ">= 1.3.4"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.24.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}