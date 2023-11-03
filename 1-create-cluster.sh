#!/bin/bash

SCRIPT_DIR="$(dirname "$0")"
VERBOSE=1
KIND_CONFIG_PATH="${SCRIPT_DIR}/environments/base/kind-config.yaml"

while [[ "$#" -gt 0 ]]; do
  case $1 in
    -c|--concise) VERBOSE=0; shift;;
    *) echo "Unknown parameter: $1"; exit 1;;
  esac
  shift
done

exec 3>&1

if [[ $VERBOSE -eq 0 ]]; then
  exec 1>/dev/null
fi

set -e

kind get clusters | grep strimzi-vs-bitnami > /dev/null 2>&1 || kind create cluster --config "$KIND_CONFIG_PATH"

echo Waiting for kind... >&3
kubectl wait --namespace kube-system --for=condition=Ready pod --all > /dev/null
