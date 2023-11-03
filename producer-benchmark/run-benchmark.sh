#!/bin/bash

set -e

SCRIPT_DIR="$(dirname "$0")"

kubectl apply -f "${SCRIPT_DIR}/kafka-utils-namespace.yaml"

kubectl run --rm -it --namespace kafka-utils --image=edenhill/kcat:1.7.1 --restart=Never --command=true kafka-producer -- sh -c 'echo "Hello, world!" | kcat -P -b clarity-cloud-kafka-bootstrap.kafka.svc.cluster.local:9092 -t benchmark'

kubectl apply --namespace kafka-utils -f "${SCRIPT_DIR}/producer-benchmark.yaml"

echo 'Waiting on job...'
kubectl wait --namespace kafka-utils --for=condition=ready pod -l job-name=kafka-producer-benchmark --timeout=5m

kubectl logs --namespace kafka-utils -f job.batch/kafka-producer-benchmark
