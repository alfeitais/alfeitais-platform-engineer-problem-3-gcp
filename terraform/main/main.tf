terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  credentials = file("plataforma-3-1093c92a4ddf.json")

  project = "plataforma-3"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_project_service" "compute_service" {
  project = "plataforma-3"
  service = "compute.googleapis.com"
}

resource "google_compute_network" "vpc_network" {
  name                            = "plataforma-3-vpc"
  auto_create_subnetworks         = false
  delete_default_routes_on_create = true
  depends_on = [
    google_project_service.compute_service
  ]
}

resource "google_compute_subnetwork" "private_network" {
  name          = "plataforma-3-private-network"
  ip_cidr_range = "10.2.0.0/16"
  network       = google_compute_network.vpc_network.self_link
}

resource "google_compute_router" "router" {
  name    = "plataforma-3-router"
  network = google_compute_network.vpc_network.self_link
}

resource "google_compute_router_nat" "nat" {
  name                               = "plataforma-3-router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_route" "private_network_internet_route" {
  name             = "plataforma-3-private-network-internet"
  dest_range       = "0.0.0.0/0"
  network          = google_compute_network.vpc_network.self_link
  next_hop_gateway = "default-internet-gateway"
  priority         = 100
}

resource "google_compute_instance" "plataforma-3-instancia" {
  boot_disk {
    auto_delete = true
    device_name = "plataforma-3-instancia"

    initialize_params {
      image = "projects/debian-cloud/global/images/debian-11-bullseye-v20230912"
      size  = 10
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  machine_type = "e2-medium"
  name         = "plataforma-3-instancia"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    subnetwork = "projects/plataforma-3/regions/us-central1/subnetworks/plataforma-3-private-network"
  }

  tags = ["app-instance"]
  zone = "us-central1-a"
}
