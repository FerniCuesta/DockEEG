#!/bin/bash

# scripts/run_mononodo.sh

THREADS_LIST=(1 2 4 8 16)

CONFIG="docker-examples/ubuntu-no-gpu/Hpmoon/config.xml"
RESULTS="results/escalabilidad_mononodo.csv"
EXEC="bin/hpmoon"
WORKDIR="docker-examples/ubuntu-no-gpu/Hpmoon"
LOGDIR="../../../logs"

# Cabecera del CSV
echo "hebras,tiempo_real,memoria_maxima" > $RESULTS

for THREADS in "${THREADS_LIST[@]}"
do
    # Cambia el valor de <CpuThreads> en config.xml (dentro del WORKDIR)
    sed -i "s/<CpuThreads>[0-9]\+<\/CpuThreads>/<CpuThreads>${THREADS}<\/CpuThreads>/" "$CONFIG"

    # Nombre significativo para el log (ruta desde la raíz del proyecto)
    LOGFILE="$LOGDIR/mononodo_${THREADS}hebras.log"

    # Ejecuta el programa desde el WORKDIR, pero guarda el log en la ruta absoluta
    (
        cd "$WORKDIR"
        /usr/bin/time -v mpirun --bind-to none --allow-run-as-root --map-by node --host localhost ./$EXEC -conf config.xml > "$LOGFILE" 2>&1
    )

    # Extrae métricas y añade al CSV (ajusta si es necesario)
    tiempo=$(grep "Elapsed (wall clock) time" "$LOGFILE" | awk '{print $8}')
    memoria=$(grep "Maximum resident set size" "$LOGFILE" | awk '{print $6}')
    echo "$THREADS,$tiempo,$memoria" >> $RESULTS
done