data "google_client_config" "current" {}

data "google_container_cluster" "host_cluster" {
  project  = var.gke_cluster_project
  name     = var.gke_cluster_name
  location = var.gke_cluster_region
}


