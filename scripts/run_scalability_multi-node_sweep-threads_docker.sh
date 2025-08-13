#!/bin/bash

# Multi-node scalability test with thread sweep in Docker

NODES_LIST=(1 2 4 8 16)
THREADS_LIST=(1 2 4 8 16)

CONFIG="docker-examples/ubuntu-no-gpu/Hpmoon/config.xml"
RESULTS="results/scalability_multi-node_sweep-threads_docker.csv"
EXEC="bin/hpmoon"
WORKDIR="docker-examples/ubuntu-no-gpu/Hpmoon"
LOGDIR="logs"
IMAGE="hpmoon-ubuntu-no-gpu:v0.0.6"

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
        echo "Starting test with $NODES nodes and $THREADS threads (Docker, total threads: $TOTAL_THREADS)..."

        # Clean the system before running the test
        ./scripts/clean_system.sh

        # Update the number of threads in the configuration file
        echo "Updating <CpuThreads> to $THREADS in $CONFIG"
        sed -i "s/<CpuThreads>[0-9]\+<\/CpuThreads>/<CpuThreads>${THREADS}<\/CpuThreads>/" "$CONFIG"

        # Build the hosts string
        HOSTS=$(yes localhost | head -n $NODES | paste -sd, -)
        LOGFILE="$LOGDIR/multinode_docker_sweep_${NODES}nodes_${THREADS}threads.log"

        # Run the program in Docker and save the log
        echo "Running the program in Docker and saving log to $LOGFILE"
        /usr/bin/time -v docker run --rm \
            -v "$PWD/$CONFIG":/root/Hpmoon/config.xml \
            -w /root/Hpmoon \
            $IMAGE \
            mpirun --bind-to none --allow-run-as-root --map-by node --host $HOSTS ./bin/hpmoon -conf config.xml > "$LOGFILE" 2>&1

        # Extract metrics from the log file
        echo "Extracting metrics from $LOGFILE"
        time=$(grep "Elapsed (wall clock) time" "$LOGFILE" | awk '{print $8}')
        max_memory=$(grep "Maximum resident set size" "$LOGFILE" | awk '{print $6}')
        cpu_percentage=$(grep "Percent of CPU this job got" "$LOGFILE" | awk -F: '{gsub(/%/,""); print $2}' | xargs)

        # Log the results
        echo "$NODES,$THREADS,$time,$max_memory,$cpu_percentage" >> $RESULTS

        echo "Test with $NODES nodes and $THREADS threads (Docker) finished."
    done
done

echo "------------------------------------------------------------"
echo "All Docker multi-node sweep tests have finished. Results in $RESULTS"