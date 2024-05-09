terraform {
  required_version = ">= 1.0.6"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.20.0"
    }
  }

  backend "gcs" {
    bucket = "tf-state-resonant-gizmo-745"
    prefix = "terraform/state/data-ingestion"
  }
}

locals {
  project = "resonant-gizmo-745"
  region  = "us-central1"
}

provider "google" {
  project = local.project
  region  = local.region
}

provider "google-beta" {
  project = local.project
  region  = local.region
}
