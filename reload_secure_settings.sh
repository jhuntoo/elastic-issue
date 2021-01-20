#! /usr/bin/env bash

set -euo pipefail

es_password=$(kubectl get secret issue-4137-reproduction-es-elastic-user -n issue-4137-reproduction -o json | jq -r '.data.elastic' | base64 -d)
echo "-> Reloading Secure Settings on all nodes"
curl -X POST -u "elastic:$es_password" "http://localhost:9200/_nodes/reload_secure_settings"