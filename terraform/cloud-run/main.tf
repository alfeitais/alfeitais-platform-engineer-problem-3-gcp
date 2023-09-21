resource "google_cloud_run_v2_service" "default" {
  name     = "app"
  location = "us-central1"
  client   = "terraform"

  template {
    containers {
      image = "us-central1-docker.pkg.dev/plataforma-3/plataforma-3-repository/javaapi:latest"
    }
  }
}

resource "google_cloud_run_v2_service_iam_member" "noauth" {
  location = google_cloud_run_v2_service.default.location
  name     = google_cloud_run_v2_service.default.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}