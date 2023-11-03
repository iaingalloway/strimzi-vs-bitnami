#!/bin/bash

SCRIPT_DIR="$(dirname "$0")"
ENVIRONMENT=""
VERBOSE=1
REPO_URL="git@github.com:iaingalloway/strimzi-vs-bitnami.git"

while [[ "$#" -gt 0 ]]; do
  case $1 in
    -c|--concise) VERBOSE=0; shift;;
    -e|--environment) ENVIRONMENT="$2"; shift 2;;
    *) echo "Unknown parameter: $1"; exit 1;;
  esac
done

if [ -z "$ENVIRONMENT" ]; then
  echo "Environment not provided. Use -e or --environment to specify it."
  exit 1
fi

APP_YAML_PATH="$SCRIPT_DIR/environments/$ENVIRONMENT/app-of-apps.yaml"

exec 3>&1

if [[ $VERBOSE -eq 0 ]]; then
  exec 1>/dev/null
fi

set -e

echo Creating app-of-apps... >&3
argocd login localhost:8880 --insecure --username admin --password "$(argocd admin initial-password -n argocd | grep -oE '[[:alnum:]-]{16}')"
argocd repo add $REPO_URL --ssh-private-key-path ~/.ssh/id_rsa
argocd app create --upsert --file "$APP_YAML_PATH"

echo Waiting for app-of-apps... >&3
argocd app wait strimzi-vs-bitnami-app-of-apps --timeout 300
