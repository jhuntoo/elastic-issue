# This resource is here so to get around the chicken-and-egg problem of having
# kubernetes secrets failing due to the non-existence of this namespace.
# https://github.com/terraform-providers/terraform-provider-kubernetes/issues/163

resource "kubernetes_namespace" "issue-4137-reproduction" {
  metadata {
    labels = {
      namespace            = "issue-4137-reproduction"
    }

    name = "issue-4137-reproduction"
  }

  lifecycle {
    ignore_changes = all
  }
}
