
#### Binary Dependencies
gcloud
kustomize: 3.5.5 
terraform: 0.13.3


### Prerequisites
- a GKE cluster
- the ECK operator 1.2.0 must be installed in the elastic-system namespace (our config is in [/operator](operator) for reference)

### 1. Build infra
- nodepool
- snapshot Service Account
- snapshot bucket
- k8s namespace
- k8s secrets

```bash
export TF_VAR_gke_cluster_project=<your gcp project>
export TF_VAR_gke_cluster_name=<your cluster name>
export TF_VAR_gke_cluster_region=<your region>
pushd terraform
terraform init
terraform plan -out=plan.tfplan
terraform apply plan.tfplan
popd
```

### 2. Apply k8s manifests
```bash
kustomize build k8s/dev | kubectl apply -f -
```

### 3. Register snapshot repo
```bash
kubectl port-forward -n issue-4137-reproduction svc/issue-4137-reproduction-es-http 9200
./register_snapshot_repo.sh
```

This should succeed, and you should see
`{"acknowledged":true}`

### 4. Create an invalid  service account key value
In [./terraform/snapshots.tf](./terraform/snapshots.tf), modify `gcs.client.default.credentials_file` in the resource `resource "kubernetes_secret" "issue-4137-reproduction-gcs-creds` to something obviously invalid, like changing the `client_email` to something that does exist.

### 5. Register the snapshot repo again (without reloading)
You may need to stop and rerun the port forwarding command, I did.
`./register_snapshot_repo.sh`
This should succeed as the secure setting has not been reloaded

### 6. Reload secure settings and Register the snapshot repo again
```bash
./reload_secure_settings.sh
./register_snapshot_repo.sh
```
This will succeed as the invalid service account key has not been refreshed correctly.

### 7. Cleanup
```bash
kustomize build k8s/dev | kubectl delete -f -
pushd terraform
terraform destroy 
```