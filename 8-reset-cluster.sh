#!/bin/bash

set -e

argocd login localhost:8880 --insecure --username admin --password "$(argocd admin initial-password -n argocd | grep -oE '[[:alnum:]-]{16}')" > /dev/null
argocd app delete -y strimzi-vs-bitnami-app-of-apps

kubectl delete all --namespace strimzi-vs-bitnami --all
