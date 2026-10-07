#!/bin/bash
# Deploy script for infra-platform-project
set -euo pipefail

ENVIRONMENT=${1:-dev}
MANIFEST="deployments/blue-green.yaml"

echo "Deploying infra-platform-project to ${ENVIRONMENT}..."

if [ ! -f "$MANIFEST" ]; then
  echo "ERROR: $MANIFEST not found." >&2
  echo "Add your blue/green Kubernetes manifests there, or pass a different path." >&2
  exit 1
fi

if ! command -v kubectl >/dev/null 2>&1; then
  echo "ERROR: kubectl not found on PATH." >&2
  exit 1
fi

echo "Executing blue-green deployment from $MANIFEST..."
kubectl apply -f "$MANIFEST"
echo "Blue-green deployment applied for ${ENVIRONMENT}."
