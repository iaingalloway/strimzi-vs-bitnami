# Producer benchmark

A kubernetes job to benchmark kafka.

Run with:

```bash
./run-benchmark.sh
```

Clean up (so you can run it again) with:

```bash
./cleanup-benchmark.sh
```

The script starts the job, waits for the job to start, and then attaches to the log file so you can view the output.

You can use kcat to listen to all the messages from a kafka instance:

```bash
kubectl run --rm -it --namespace kafka-utils --image=edenhill/kcat:1.7.1 --restart=Never kafka-client -- -b clarity-cloud-kafka-bootstrap.kafka.svc.cluster.local:9092 -G all -o end ^*
```
