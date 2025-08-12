#!/bin/bash

# scripts/run_single-node.sh

THREADS_LIST=(1 2 4 8 16)

CONFIG="docker-examples/ubuntu-no-gpu/Hpmoon/config.xml"
RESULTS="results/scalability_single-node_native.csv"
EXEC="bin/hpmoon"
WORKDIR="docker-examples/ubuntu-no-gpu/Hpmoon"
LOGDIR="logs"

# CSV header
echo "threads,time,max_memory,cpu_percentage" > $RESULTS

for THREADS in "${THREADS_LIST[@]}"
do
    echo "------------------------------------------------------------"
    echo "Starting test with $THREADS threads..."
    echo "Running system cleanup..."
    ./scripts/clean_system.sh

    echo "Updating <CpuThreads> to $THREADS in $CONFIG"
    sed -i "s/<CpuThreads>[0-9]\+<\/CpuThreads>/<CpuThreads>${THREADS}<\/CpuThreads>/" "$CONFIG"

    LOGFILE="$LOGDIR/single-node_${THREADS}threads.log"
    LOGFILE_RELATIVE="$(realpath --relative-to="$WORKDIR" "$LOGFILE")"

    echo "Running the program and saving log to $LOGFILE"
    (
        cd "$WORKDIR"
        /usr/bin/time -v mpirun --bind-to none --allow-run-as-root --map-by node --host localhost ./$EXEC -conf config.xml -ns $THREADS > "$LOGFILE_RELATIVE" 2>&1
    )

    echo "Extracting metrics from $LOGFILE"
    real_time=$(grep "Elapsed (wall clock) time" "$LOGFILE" | awk '{print $8}')
    max_memory=$(grep "Maximum resident set size" "$LOGFILE" | awk '{print $6}')
    cpu_percentage=$(grep "Percent of CPU this job got" "$LOGFILE" | awk -F: '{gsub(/%/,""); print $2}' | xargs)
    echo "$THREADS,$real_time,$max_memory,$cpu_percentage" >> $RESULTS
    echo "Test with $THREADS threads finished."
done

echo "------------------------------------------------------------"
echo "All tests have finished. Results in $RESULTS"