#!/bin/bash

THREADS_LIST=(1 2 4 8 16)

CONFIG="docker-examples/ubuntu-no-gpu/Hpmoon/config.xml"
RESULTS="results/escalabilidad_mononodo_docker.csv"
EXEC="bin/hpmoon"
WORKDIR="docker-examples/ubuntu-no-gpu/Hpmoon"
LOGDIR="logs"
IMAGE="hpmoon-ubuntu-no-gpu:v0.0.5"

mkdir -p "$LOGDIR"

echo "hebras,tiempo_real,memoria_maxima,cpu_porcentaje" > $RESULTS

for THREADS in "${THREADS_LIST[@]}"
do
    echo "------------------------------------------------------------"
    echo "Iniciando prueba con $THREADS hebras (Docker)..."
    ./scripts/clean_system.sh

    echo "Actualizando <CpuThreads> a $THREADS en $CONFIG"
    sed -i "s/<CpuThreads>[0-9]\+<\/CpuThreads>/<CpuThreads>${THREADS}<\/CpuThreads>/" "$CONFIG"

    LOGFILE="$LOGDIR/mononodo_docker_${THREADS}hebras.log"

    echo "Ejecutando el programa en Docker y guardando log en $LOGFILE"
    /usr/bin/time -v docker run --rm \
        -v "$PWD":/workspace \
        -w /workspace/$WORKDIR \
        $IMAGE \
        mpirun --bind-to none --allow-run-as-root --map-by node --host localhost ./$EXEC -conf config.xml > "$LOGFILE" 2>&1

    echo "Extrayendo métricas de $LOGFILE"
    tiempo=$(grep "Elapsed (wall clock) time" "$LOGFILE" | awk '{print $8}')
    memoria=$(grep "Maximum resident set size" "$LOGFILE" | awk '{print $6}')
    cpu_porcentaje=$(grep "Percent of CPU this job got" "$LOGFILE" | awk -F: '{gsub(/%/,""); print $2}' | xargs)
    echo "$THREADS,$tiempo,$memoria,$cpu_porcentaje" >> $RESULTS
    echo "Prueba con $THREADS hebras (Docker) finalizada."
done

echo "------------------------------------------------------------"
echo "Todas las pruebas en Docker han finalizado. Resultados en $RESULTS"