#!/bin/bash

NODES=1
THREADS_LIST=(1 2 4 8 16)

CONFIG="docker-examples/ubuntu-no-gpu/Hpmoon/config.xml"
RESULTS="results/scalability_single-node_docker.csv"
EXEC="bin/hpmoon"
WORKDIR="docker-examples/ubuntu-no-gpu/Hpmoon"
LOGDIR="logs"
IMAGE="hpmoon-ubuntu-no-gpu:v0.0.5"

echo "nodes,threads,time,max_memory,cpu_percentage" > $RESULTS

for THREADS in "${THREADS_LIST[@]}"
do
    echo "------------------------------------------------------------"
    echo "Starting test with $THREADS threads (Docker)..."

    # Clean the system before running the test
    ./scripts/clean_system.sh

    # Change the number of threads in the configuration file
    echo "Updating <CpuThreads> to $THREADS in $CONFIG"
    sed -i "s/<CpuThreads>[0-9]\+<\/CpuThreads>/<CpuThreads>${THREADS}<\/CpuThreads>/" "$CONFIG"

    # Change the logfile name to include the number of threads
    LOGFILE="$LOGDIR/mononode_docker_${THREADS}threads.log"

    # Run the program in Docker and save the log
    echo "Running the program in Docker and saving log to $LOGFILE"
    /usr/bin/time -v docker run --rm \
    -v "$PWD/$CONFIG":/root/Hpmoon/config.xml \
    $IMAGE > "$LOGFILE" 2>&1

    # Extract metrics from the log file
    echo "Extracting metrics from $LOGFILE"
    real_time=$(grep "Elapsed (wall clock) time" "$LOGFILE" | awk '{print $8}')
    max_memory=$(grep "Maximum resident set size" "$LOGFILE" | awk '{print $6}')
    cpu_percentage=$(grep "Percent of CPU this job got" "$LOGFILE" | awk -F: '{gsub(/%/,""); print $2}' | xargs)

    # Log the results
    echo "$NODES,$THREADS,$real_time,$max_memory,$cpu_percentage" >> $RESULTS

    echo "Test with $THREADS threads (Docker) finished."
done

echo "------------------------------------------------------------"
echo "All Docker tests have finished. Results in $RESULTS"