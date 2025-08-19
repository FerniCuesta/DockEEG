#!/bin/bash

# Multi-node scalability test with thread sweep in Native

NODES_LIST=(1 2 4 8 16)
THREADS_LIST=(1 2 4 8 16)

BASE_DIR="docker-examples/ubuntu-gpu"
CONFIG="$BASE_DIR/Hpmoon/config.xml"
RESULTS_DIR="results"
RESULTS="$RESULTS_DIR/scalability_multi-node_sweep-threads_native.csv"
EXEC="bin/hpmoon"
WORKDIR="$BASE_DIR/Hpmoon"
LOGDIR="logs"

# Create directories if they do not exist
mkdir -p "$RESULTS_DIR" "$LOGDIR"

# CSV header
echo "nodes,threads,time,max_memory,cpu_percentage" > $RESULTS

for NODES in "${NODES_LIST[@]}"
do
    for THREADS in "${THREADS_LIST[@]}"
    do
        TOTAL_THREADS=$((NODES * THREADS))
        if [ "$TOTAL_THREADS" -gt 16 ]; then
            echo "Skipping: $NODES nodes x $THREADS threads = $TOTAL_THREADS (exceeds the limit of 16)"
            continue
        fi

        echo "------------------------------------------------------------"
        echo "Starting test with $NODES nodes and $THREADS threads (total threads: $TOTAL_THREADS)..."

        # Clean the system before running the test
        ./scripts/clean_system.sh

        # Update the number of threads in the configuration file
        echo "Updating <CpuThreads> to $THREADS in $CONFIG"
        sed -i "s/<CpuThreads>[0-9]\+<\/CpuThreads>/<CpuThreads>${THREADS}<\/CpuThreads>/" "$CONFIG"

        # Build the hosts string
        HOSTS=$(yes localhost | head -n $NODES | paste -sd, -)
        LOGFILE="$LOGDIR/multinode_sweep_${NODES}nodes_${THREADS}threads.log"
        LOGFILE_RELATIVE="$(realpath --relative-to="$WORKDIR" "$LOGFILE")"

        # Run the program and save the log
        echo "Running the program and saving log to $LOGFILE"
        (
            cd "$WORKDIR"
            /usr/bin/time -v mpirun --bind-to none --allow-run-as-root --map-by node --host $HOSTS ./$EXEC -conf config.xml > "$LOGFILE_RELATIVE" 2>&1
        )

        # Extract metrics from the log file
        echo "Extracting metrics from $LOGFILE"
        time=$(grep "Elapsed (wall clock) time" "$LOGFILE" | awk '{print $8}')
        memory=$(grep "Maximum resident set size" "$LOGFILE" | awk '{print $6}')
        cpu_percentage=$(grep "Percent of CPU this job got" "$LOGFILE" | awk -F: '{gsub(/%/,""); print $2}' | xargs)

        # Log the results
        echo "$NODES,$THREADS,$time,$memory,$cpu_percentage" >> $RESULTS

        echo "Test with $NODES nodes and $THREADS threads finished."
    done
done