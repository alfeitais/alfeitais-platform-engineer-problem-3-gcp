resource "google_compute_network" "auto-vpc-tf" {
  name = "auto-vpc-tf"
  auto_create_subnetworks = true
}

resource "google_compute_network" "plataforma-3-vpc-tf" {
  name = "plataforma-3-vpc-tf"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "sub-sg" {
  name = "sub-sg"
  network = google_compute_network.plataforma-3-vpc-tf.id
  ip_cidr_range = "10.1.0.0/24"
  region = "us-central1"
  private_ip_google_access = true
}

resource "google_compute_firewall" "allow-icmp" {
  name = "allow-icmp"
  network = google_compute_network.plataforma-3-vpc-tf.id
  allow {
    protocol = "icmp"
  }
  source_ranges = ["201.51.203.184/32"]
  priority = 455
}

resource "google_compute_firewall" "allow-tcp" {
  name = "allow-tcp"
  network = google_compute_network.plataforma-3-vpc-tf.id
  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }
  source_ranges = ["0.0.0.0/0"]
}

output "auto" {
  value = google_compute_network.auto-vpc-tf
}

output "custom" {
  value = google_compute_network.plataforma-3-vpc-tf
}
