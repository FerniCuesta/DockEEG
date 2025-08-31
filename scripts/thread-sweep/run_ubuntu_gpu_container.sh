#!/bin/bash

# Configuration
BASE_DIR="${1:-docker-examples/ubuntu-gpu}"
WORKDIR="${2:-$BASE_DIR/Hpmoon}"
RESULTS_DIR="${3:-results}"
EXEC="${4:-bin/hpmoon}"
LOGDIR="${5:-logs}"

CONFIG="$WORKDIR/config.xml"
IMAGE="hpmoon-ubuntu-gpu:v0.0.1"

# Test parameters
CONTAINER_LIST=("docker" "podman")
NODES_LIST=(1 2 4 8 16)
THREADS_LIST=(1 2 4 8 16)

# Create directories if they do not exist
mkdir -p "$RESULTS_DIR" "$LOGDIR"

for CONTAINER in "${CONTAINER_LIST[@]}"
do
    RESULTS="$RESULTS_DIR/thread-sweep/ubuntu_${CONTAINER}_gpu.csv"
    
    # CSV header
    echo "nodes,threads,time,max_memory,cpu_percentage" > "$RESULTS"

    for NODES in "${NODES_LIST[@]}"
    do
        for THREADS in "${THREADS_LIST[@]}"
        do
            TOTAL_THREADS=$((NODES * THREADS))
            # If commented it allows to exceed the limit of 16 threads
            # if [ "$TOTAL_THREADS" -gt 16 ]; then
            #     echo "Skipping: $NODES nodes x $THREADS threads = $TOTAL_THREADS (exceeds the limit of 16)"
            #     continue
            # fi

            echo "------------------------------------------------------------"
            echo "Starting test with $NODES nodes and $THREADS threads ($CONTAINER, total threads: $TOTAL_THREADS)..."

            # Clean the system before running the test
            # ./scripts/clean_system.sh

            # Update the number of threads in the configuration file
            echo "Updating <CpuThreads> to $THREADS in $CONFIG"
            sed -i "s/<CpuThreads>[0-9]\+<\/CpuThreads>/<CpuThreads>${THREADS}<\/CpuThreads>/" "$CONFIG"

            # Build the hosts string
            HOSTS=$(yes localhost | head -n $NODES | paste -sd, -)
            LOGFILE="$LOGDIR/thread-sweep/ubuntu_${CONTAINER}_gpu_${NODES}nodes_${THREADS}threads.log"

            # Run the program in Docker or Podman and save the log
            echo "Running the program in $CONTAINER and saving log to $LOGFILE"
            /usr/bin/time -v $CONTAINER run --rm \
                --device nvidia.com/gpu=all \
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
            echo "$NODES,$THREADS,$time,$max_memory,$cpu_percentage" >> "$RESULTS"

            echo "Test with $NODES nodes and $THREADS threads ($CONTAINER) finished."
        done
    done
done

echo "------------------------------------------------------------"
echo "All Ubuntu thread-sweep container tests have finished. Results in $RESULTS"