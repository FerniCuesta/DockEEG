#!/bin/bash

CONTAINER_LIST=("docker" "podman")
NODES_LIST=(1 2 4 8 16)
THREADS=1

CONFIG="docker-examples/ubuntu-no-gpu/Hpmoon/config.xml"
RESULTS_DIR="results"
EXEC="bin/hpmoon"
WORKDIR="docker-examples/ubuntu-no-gpu/Hpmoon"
LOGDIR="logs"
IMAGE="hpmoon-ubuntu-no-gpu:v0.0.6"

# Create directories if they do not exist
mkdir -p "$RESULTS_DIR" "$LOGDIR"

for CONTAINER in "${CONTAINER_LIST[@]}"
do
    RESULTS="$RESULTS_DIR/scalability_multi-node_${CONTAINER}.csv"
    # CSV header
    echo "nodes,threads,time,max_memory,cpu_percentage" > "$RESULTS"

    for NODES in "${NODES_LIST[@]}"
    do
        echo "------------------------------------------------------------"
        echo "Starting test with $NODES nodes and $THREADS threads ($CONTAINER)..."

        # Clean the system before running the test
        ./scripts/clean_system.sh

        # Change the number of threads in the configuration file
        echo "Updating <CpuThreads> to $THREADS in $CONFIG"
        sed -i "s/<CpuThreads>[0-9]\+<\/CpuThreads>/<CpuThreads>${THREADS}<\/CpuThreads>/" "$CONFIG"

        # Build the hosts string
        HOSTS=$(yes localhost | head -n $NODES | paste -sd, -)

        # Change the logfile name to include the number of threads and container
        LOGFILE="$LOGDIR/multi-node_${CONTAINER}_${NODES}nodes_${THREADS}threads.log"

        # Run the program in Docker or Podman and save the log
        echo "Running the program in $CONTAINER and saving log to $LOGFILE"
        /usr/bin/time -v $CONTAINER run --rm \
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

echo "------------------------------------------------------------"
echo "All multinode tests have finished. Results in $RESULTS_DIR"