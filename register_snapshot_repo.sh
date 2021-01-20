#! /usr/bin/env bash

set -euo pipefail

es_password=$(kubectl get secret issue-4137-reproduction-es-elastic-user -n issue-4137-reproduction -o json | jq -r '.data.elastic' | base64 -d)

snapshot_repo='{
      "type": "gcs",
      "settings": {
          "bucket": "issue-4137-reproduction",
          "client": "default"
      }
  }'

curl \
  -X PUT \
  -H 'Content-Type: application/json' \
  -d "${snapshot_repo}" \
  "http://elastic:${es_password}@localhost:9200/_snapshot/issue-4137-reproduction-gcs"