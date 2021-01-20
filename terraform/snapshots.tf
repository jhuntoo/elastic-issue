
resource "google_service_account" "issue-4137-reproduction" {
  account_id   = "issue-4137-reproduction"
  display_name = "issue-4137-reproduction)"
}

resource "google_storage_bucket" "issue-4137-reproduction" {
  name                        = "issue-4137-reproduction"
  location                    = "EU"
  uniform_bucket_level_access = true
  force_destroy               = false
}

resource "google_storage_bucket_iam_member" "issue-4137-reproduction" {
  bucket = google_storage_bucket.issue-4137-reproduction.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.issue-4137-reproduction.email}"
}

resource "google_service_account_key" "issue-4137-reproduction" {
  service_account_id = google_service_account.issue-4137-reproduction.name
}

resource "kubernetes_secret" "issue-4137-reproduction-gcs-creds" {
  metadata {
    name      = "issue-4137-reproduction-gcs-creds"
    namespace = kubernetes_namespace.issue-4137-reproduction.id
    labels = {
      "velero.io/exclude-from-backup" = true
    }
  }

  data = {
//    "gcs.client.default.credentials_file" = base64decode(google_service_account_key.issue-4137-reproduction.private_key)
    "gcs.client.default.credentials_file" = "dummy"
  }
}
