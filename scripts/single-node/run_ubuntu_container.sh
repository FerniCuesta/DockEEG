#!/bin/bash

# Configuration
BASE_DIR="${1:-docker-examples/ubuntu-no-gpu}"
WORKDIR="${2:-$BASE_DIR/Hpmoon}"
RESULTS_DIR="${3:-results}"
EXEC="${4:-bin/hpmoon}"
LOGDIR="${5:-logs}"

CONFIG="$WORKDIR/config.xml"
IMAGE="hpmoon-ubuntu-no-gpu:v0.0.5"

# Test parameters
CONTAINER_LIST=("docker" "podman")
NODES=1
THREADS_LIST=(1 2 4 8 16)

# Create directories if they do not exist
mkdir -p "$RESULTS_DIR" "$LOGDIR"

for CONTAINER in "${CONTAINER_LIST[@]}"
do
    RESULTS="$RESULTS_DIR/single-node/ubuntu_${CONTAINER}.csv"

    # CSV header
    echo "nodes,threads,time,max_memory,cpu_percentage" > "$RESULTS"

    for THREADS in "${THREADS_LIST[@]}"
    do
        echo "------------------------------------------------------------"
        echo "Starting test with $THREADS threads ($CONTAINER)..."

        # Clean the system before running the test
        # ./scripts/clean_system.sh

        # Change the number of threads in the configuration file
        echo "Updating <CpuThreads> to $THREADS in $CONFIG"
        sed -i "s/<CpuThreads>[0-9]\+<\/CpuThreads>/<CpuThreads>${THREADS}<\/CpuThreads>/" "$CONFIG"

        # Change the logfile name to include the number of threads and container
        LOGFILE="$LOGDIR/single-node/ubuntu_${CONTAINER}_${THREADS}threads.log"

        # Run the program in Docker or Podman and save the log
        echo "Running the program in $CONTAINER and saving log to $LOGFILE"
        /usr/bin/time -v $CONTAINER run --rm \
            -v "$PWD/$CONFIG":/root/Hpmoon/config.xml \
            $IMAGE > "$LOGFILE" 2>&1

        # Extract metrics from the log file
        echo "Extracting metrics from $LOGFILE"
        time=$(grep "Elapsed (wall clock) time" "$LOGFILE" | awk '{print $8}')
        max_memory=$(grep "Maximum resident set size" "$LOGFILE" | awk '{print $6}')
        cpu_percentage=$(grep "Percent of CPU this job got" "$LOGFILE" | awk -F: '{gsub(/%/,""); print $2}' | xargs)

        # Log the results
        echo "$NODES,$THREADS,$time,$max_memory,$cpu_percentage" >> "$RESULTS"

        echo "Test with $THREADS threads ($CONTAINER) finished."
    done
done

echo "------------------------------------------------------------"
echo "All Ubuntu Single-Node Container tests have finished. Results in $RESULTS"