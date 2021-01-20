terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.39.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.39.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 1.13.2"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 2.3.0"
    }
  }
}

provider "google" {
  project = var.gke_cluster_project
}

provider "google-beta" {
  project = var.gke_cluster_project
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.host_cluster.endpoint}"
  config_context_cluster = data.google_container_cluster.host_cluster.name

  cluster_ca_certificate = base64decode(data.google_container_cluster.host_cluster.master_auth.0.cluster_ca_certificate)
  token                  = data.google_client_config.current.access_token
  config_path            = "/tmp/tf-kube-config"
  load_config_file       = false
}

provider "random" {}
