#!/bin/bash

SCRIPT_DIR="$(dirname "$0")"
VERBOSE=1
ARGOCD_PATH="${SCRIPT_DIR}/environments/base/argocd"
INGRESS_NGINX_PATH="${SCRIPT_DIR}/environments/base/ingress-nginx"

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

echo Installing Argo CD... >&3
kubectl apply -n argocd -k "$ARGOCD_PATH"

echo Installing ingress-nginx... >&3
kubectl apply -n ingress-nginx -k "$INGRESS_NGINX_PATH"

echo Waiting for Argo CD... >&3
kubectl wait --namespace argocd --for=condition=available deploy argocd-server --timeout=5m
kubectl wait --namespace argocd --for=condition=ready pod -l app.kubernetes.io/name=argocd-server --timeout=5m

echo Waiting for ingress-nginx... >&3
kubectl wait --namespace ingress-nginx --for=condition=ready pod -l app.kubernetes.io/component=controller --timeout=5m
