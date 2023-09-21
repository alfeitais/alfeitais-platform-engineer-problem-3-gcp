resource "google_artifact_registry_repository" "plataforma-3-repository" {
  location      = "us-central1"
  repository_id = "plataforma-3-repository"
  description   = "plataforma-3 images repository"
  format        = "DOCKER"

  docker_config {
    immutable_tags = false
  }
}

data "google_artifact_registry_repository" "plataforma-3-repository" {
  location      = "us-central1"
  repository_id = "plataforma-3-repository"
}