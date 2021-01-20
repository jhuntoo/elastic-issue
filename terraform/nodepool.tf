##
## This creates the nodepool hosting the ES cluster.
##


resource "google_container_node_pool" "nodepool" {
  project            = data.google_container_cluster.host_cluster.project
  cluster            = data.google_container_cluster.host_cluster.name
  location           = data.google_container_cluster.host_cluster.location
  name               = "issue-4137-reproduction"
  node_count         = 2

  node_config {
    machine_type    = "n1-standard-4"
    service_account = "${data.google_container_cluster.host_cluster.name}@${data.google_container_cluster.host_cluster.project}.iam.gserviceaccount.com"
    disk_size_gb    = 100

    oauth_scopes = ["cloud-platform"]

    labels = {
      nodepool = "issue-4137-reproduction"
    }

    taint {
      key    = "app"
      value  = "elastic"
      effect = "NO_SCHEDULE"
    }
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  management {
    auto_repair  = true
    auto_upgrade = false
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [version, node_config.0.metadata, initial_node_count]
  }

}
