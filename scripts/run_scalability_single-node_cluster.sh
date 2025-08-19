#!/bin/bash
set -euo pipefail

# Ajusta si hace falta
IMAGE="ferniicueesta/hpmoon-ubuntu-no-gpu:v0.0.6"
CONFIG_REL="docker-examples/ubuntu-no-gpu/Hpmoon/config.xml"
RESULTS_DIR="results"
RESULTS="$RESULTS_DIR/scalability_single-node_cluster.csv"
THREADS_LIST=(1 2 4 8 16)
NAMESPACE="${NAMESPACE:-default}"
LOGDIR="logs"

# Create directories if they do not exist
mkdir -p "$RESULTS_DIR" "$LOGDIR"

# Verifica kubectl/context
if ! command -v kubectl >/dev/null 2>&1; then
  echo "kubectl no está instalado o no está en PATH" >&2
  exit 1
fi
kubectl version --client >/dev/null

# Cabecera CSV si no existe
if [ ! -f "$RESULTS" ]; then
  echo "timestamp,nodes,container,threads,elapsed_time,max_memory_kb,cpu_percent" > "$RESULTS"
fi

for THREADS in "${THREADS_LIST[@]}"; do
  JOB_NAME="hpmoon-test-${THREADS}"

  # Crear/actualizar ConfigMap con el config.xml local
  if [ ! -f "$PWD/$CONFIG_REL" ]; then
    echo "No se encontró $CONFIG_REL en el directorio actual" >&2
    exit 1
  fi

  # Actualiza el config.xml localmente antes de crear el ConfigMap
  echo "Updating <CpuThreads> to $THREADS in $CONFIG_REL"
  sed -i "s/<CpuThreads>[0-9]\+<\/CpuThreads>/<CpuThreads>${THREADS}<\/CpuThreads>/" "$CONFIG_REL"

  # Crea/actualiza el ConfigMap con el config.xml actualizado
  kubectl create configmap hpmoon-config --from-file=config.xml="$PWD/$CONFIG_REL" -n "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

  echo "=== Ejecutando job=${JOB_NAME} threads=${THREADS} image=${IMAGE} ==="

  # Genera manifiesto del Job (usa ConfigMap montado en /config)
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

  # Esperar a completar
  kubectl wait --for=condition=complete job/${JOB_NAME} -n "${NAMESPACE}" || echo "Timeout/ fallo en job ${JOB_NAME} (revisar logs)"

  # Obtener pod y logs
  POD=$(kubectl get pods -n "${NAMESPACE}" -l job-name=${JOB_NAME} -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)
  if [ -n "$POD" ]; then
    kubectl logs "${POD}" -n "${NAMESPACE}" > "${LOGDIR}/${JOB_NAME}.log" 2>&1 || true
  else
    echo "No se encontró pod para job ${JOB_NAME}, marcando NA en CSV"
    echo "$(date -Iseconds),1,${IMAGE},${THREADS},NA,NA,NA" >> "$RESULTS"
    kubectl delete job "${JOB_NAME}" -n "${NAMESPACE}" --ignore-not-found
    continue
  fi

  # Extraer métricas (siempre revisar el formato de salida de /usr/bin/time en tu imagen)
  elapsed=$(grep "Elapsed (wall clock) time" "${LOGDIR}/${JOB_NAME}.log" | awk '{print $8}' || echo NA)
  max_mem=$(grep "Maximum resident set size" "${LOGDIR}/${JOB_NAME}.log" | awk '{print $6}' || echo NA)
  cpu_pct=$(grep "Percent of CPU this job got" "${LOGDIR}/${JOB_NAME}.log" | awk -F: '{gsub(/%/,""); print $2}' | xargs || echo NA)
  timestamp=$(date -Iseconds)

  echo "${timestamp},1,${IMAGE},${THREADS},${elapsed},${max_mem},${cpu_pct}" >> "$RESULTS"

  # Limpieza del Job (pods se mantendrán por poco tiempo; borramos job para no acumular)
  kubectl delete job "${JOB_NAME}" -n "${NAMESPACE}" --ignore-not-found
  rm -f /tmp/job-${JOB_NAME}.yaml
done

echo "Todas las pruebas finalizadas. CSV: $RESULTS  Logs: $LOGDIR/"