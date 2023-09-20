terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.85.0"
    }
  }
}

provider "google" {
  project = "plataforma-3"
  region = "us-central1"
  zone = "us-central1-a"
  credentials = "../keys.json"
}

resource google_storage_bucket "GCS1"{
  name = "bucket-plataforma-3-tf-sa"
}