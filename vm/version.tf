terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 1.7.3"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 5.16.0"
    }
  }
  required_version = ">= 1.7.2"
}

