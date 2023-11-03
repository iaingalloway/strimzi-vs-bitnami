#!/bin/bash

VERBOSE=1

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

echo Waiting for Argo CD... >&3
kubectl wait --namespace argocd --for=condition=available deploy argocd-server --timeout=5m
kubectl wait --namespace argocd --for=condition=ready pod -l app.kubernetes.io/name=argocd-server --timeout=5m
echo For the Argo CD dashboard, browse to https://localhost:8880 >&3

echo Waiting on kafka... >&3

argocd app wait kafdrop --sync --timeout 1800
argocd app wait kafdrop --operation --timeout 1800
argocd app wait kafdrop --health --timeout 1800

echo For Kafdrop, browse to http://localhost:8881 >&3
