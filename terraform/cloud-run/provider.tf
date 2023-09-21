terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.83.0"
    }
  }
}

provider "google" {
  # Configuration options
  project     = "plataforma-3"
  region      = "us-central1"
  zone        = "us-central1-a"
  credentials = "../keys.json"
}











