#!/usr/bin/env bash
set -euo pipefail

echo "Checking Kubernetes connection..."
kubectl --context kind-learning get nodes

echo "Kubernetes connection check passed."
