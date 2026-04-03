#!/bin/bash
# Deploy script for infra-platform

set -euo pipefail

ENVIRONMENT=${1:-dev}

echo "🚀 Deploying infra-platform to ${ENVIRONMENT}..."



echo "Executing blue-green deployment..."
kubectl apply -f deployments/blue-green.yaml
echo "✅ Blue-green deployment initiated"


echo "🎉 Deployment to ${ENVIRONMENT} complete!"
