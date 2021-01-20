
resource "random_string" "grafana_password" {
  length  = 21
  special = false
}

resource "kubernetes_secret" "issue-4137-reproduction" {
  metadata {
    name      = "issue-4137-reproduction-passwords"
    namespace = kubernetes_namespace.issue-4137-reproduction.id
    labels = {
      app = "jldp-logging"
      "velero.io/exclude-from-backup" = true
    }
  }

  data = {
    GRAFANA_PASSWORD             = random_string.grafana_password.result
  }
}
