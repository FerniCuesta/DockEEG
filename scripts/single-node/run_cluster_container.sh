#!/bin/bash
set -euo pipefail

# Configuration
BASE_DIR="${1:-docker-examples/ubuntu-no-gpu}"
WORKDIR="${2:-$BASE_DIR/Hpmoon}"
RESULTS_DIR="${3:-results}"
EXEC="${4:-bin/hpmoon}"
LOGDIR="${5:-logs}"

CONFIG="$WORKDIR/config.xml"
IMAGE="ferniicueesta/hpmoon-ubuntu-no-gpu:v0.0.6"
NAMESPACE="${NAMESPACE:-default}"
RESULTS="$RESULTS_DIR/single-node_cluster_container.csv"

# Test parameters
CONTAINER_LIST=("docker" "podman")
NODES=1
THREADS_LIST=(1 2 4 8 16)

# Create directories if they do not exist
mkdir -p "$RESULTS_DIR" "$LOGDIR"

# Check kubectl/context
if ! command -v kubectl >/dev/null 2>&1; then
  echo "kubectl is not installed or not in PATH" >&2
  exit 1
fi
kubectl version --client >/dev/null

for CONTAINER in "${CONTAINER_LIST[@]}"
do
  RESULTS="$RESULTS_DIR/single-node/cluster_${CONTAINER}.csv"

  # CSV header
  echo "timestamp,nodes,container,threads,elapsed_time,max_memory_kb,cpu_percent" > "$RESULTS"

  for THREADS in "${THREADS_LIST[@]}"; do
    JOB_NAME="hpmoon-test-${THREADS}"

    # Create/update ConfigMap with local config.xml
    if [ ! -f "$PWD/$CONFIG" ]; then
      echo "Could not find $CONFIG in current directory" >&2
      exit 1
    fi

    # Update config.xml locally before creating the ConfigMap
    echo "Updating <CpuThreads> to $THREADS in $CONFIG"
    sed -i "s/<CpuThreads>[0-9]\+<\/CpuThreads>/<CpuThreads>${THREADS}<\/CpuThreads>/" "$CONFIG"

    # Create/update the ConfigMap with the updated config.xml
    kubectl create configmap hpmoon-config --from-file=config.xml="$PWD/$CONFIG" -n "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

    echo "=== Running job=${JOB_NAME} threads=${THREADS} image=${IMAGE} ==="

    # Generate Job manifest (mount ConfigMap at /config)
    cat > /tmp/job-${JOB_NAME}.yaml <<EOF
apiVersion: batch/v1
kind: Job
metadata:
  name: ${JOB_NAME}
  namespace: ${NAMESPACE}
spec:
  backoffLimit: 1
  template:
    spec:
      restartPolicy: Never
      containers:
      - name: hpmoon
        image: ${IMAGE}
        volumeMounts:
        - name: config
          mountPath: /config
      volumes:
      - name: config
        configMap:
          name: hpmoon-config
EOF

    kubectl apply -f /tmp/job-${JOB_NAME}.yaml

    # Wait for completion
    kubectl wait --for=condition=complete job/${JOB_NAME} -n "${NAMESPACE}" || echo "Timeout/failure in job ${JOB_NAME} (check logs)"

    # Get pod and logs
    POD=$(kubectl get pods -n "${NAMESPACE}" -l job-name=${JOB_NAME} -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)
    if [ -n "$POD" ]; then
      kubectl logs "${POD}" -n "${NAMESPACE}" > "${LOGDIR}/${JOB_NAME}.log" 2>&1 || true
    else
      echo "No pod found for job ${JOB_NAME}, marking NA in CSV"
      echo "$(date -Iseconds),1,${IMAGE},${THREADS},NA,NA,NA" >> "$RESULTS"
      kubectl delete job "${JOB_NAME}" -n "${NAMESPACE}" --ignore-not-found
      continue
    fi

    # Extract metrics (always check the output format of /usr/bin/time in your image)
    elapsed=$(grep "Elapsed (wall clock) time" "${LOGDIR}/${JOB_NAME}.log" | awk '{print $8}' || echo NA)
    max_mem=$(grep "Maximum resident set size" "${LOGDIR}/${JOB_NAME}.log" | awk '{print $6}' || echo NA)
    cpu_pct=$(grep "Percent of CPU this job got" "${LOGDIR}/${JOB_NAME}.log" | awk -F: '{gsub(/%/,""); print $2}' | xargs || echo NA)
    timestamp=$(date -Iseconds)

    echo "${timestamp},1,${IMAGE},${THREADS},${elapsed},${max_mem},${cpu_pct}" >> "$RESULTS"

    # Cleanup the Job (pods will remain for a short time; delete job to avoid accumulation)
    kubectl delete job "${JOB_NAME}" -n "${NAMESPACE}" --ignore-not-found
    rm -f /tmp/job-${JOB_NAME}.yaml
  done
done

echo "All tests finished. CSV: $RESULTS  Logs: $LOGDIR/"