#!/bin/bash

set -e

SCRIPT_DIR="$(dirname "$0")"

"$SCRIPT_DIR/1-create-cluster.sh" --concise
"$SCRIPT_DIR/2-install-prerequisites.sh" --concise
"$SCRIPT_DIR/3-apply-manifests.sh" --concise --environment strimzi
time "$SCRIPT_DIR/4-get-details.sh" --concise
