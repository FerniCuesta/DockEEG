#!/bin/bash

# scripts/run_mononodo.sh

THREADS_LIST=(16)

CONFIG="docker-examples/ubuntu-no-gpu/Hpmoon/config.xml"
RESULTS="results/escalabilidad_mononodo.csv"
EXEC="bin/hpmoon"
WORKDIR="docker-examples/ubuntu-no-gpu/Hpmoon"
LOGDIR="logs"

# Cabecera del CSV (añadimos cpu_porcentaje)
echo "hebras,tiempo_real,memoria_maxima,cpu_porcentaje" > $RESULTS

for THREADS in "${THREADS_LIST[@]}"
do
    echo "------------------------------------------------------------"
    echo "Iniciando prueba con $THREADS hebras..."
    echo "Ejecutando limpieza previa del sistema..."
    ./scripts/clean_system.sh

    echo "Actualizando <CpuThreads> a $THREADS en $CONFIG"
    sed -i "s/<CpuThreads>[0-9]\+<\/CpuThreads>/<CpuThreads>${THREADS}<\/CpuThreads>/" "$CONFIG"

    LOGFILE="$LOGDIR/mononodo_${THREADS}hebras.log"
    LOGFILE_RELATIVE="$(realpath --relative-to="$WORKDIR" "$LOGFILE")"

    echo "Ejecutando el programa y guardando log en $LOGFILE"
    (
        cd "$WORKDIR"
        /usr/bin/time -v mpirun --bind-to none --allow-run-as-root --map-by node --host localhost ./$EXEC -conf config.xml > "$LOGFILE_RELATIVE" 2>&1
    )

    echo "Extrayendo métricas de $LOGFILE"
    tiempo=$(grep "Elapsed (wall clock) time" "$LOGFILE" | awk '{print $8}')
    memoria=$(grep "Maximum resident set size" "$LOGFILE" | awk '{print $6}')
    cpu_porcentaje=$(grep "Percent of CPU this job got" "$LOGFILE" | awk -F: '{gsub(/%/,""); print $2}' | xargs)
    echo "$THREADS,$tiempo,$memoria,$cpu_porcentaje" >> $RESULTS
    echo "Prueba con $THREADS hebras finalizada."
done

echo "------------------------------------------------------------"
echo "Todas las pruebas han finalizado. Resultados en $RESULTS"