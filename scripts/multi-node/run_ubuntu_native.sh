#!/bin/bash

# Configuration
BASE_DIR="${1:-docker-examples/ubuntu-gpu}"
WORKDIR="${2:-$BASE_DIR/Hpmoon}"
RESULTS_DIR="${3:-results}"
EXEC="${4:-bin/hpmoon}"
LOGDIR="${5:-logs}"

CONFIG="$WORKDIR/config.xml"
RESULTS="$RESULTS_DIR/multi-node/ubuntu_native.csv"

# Test parameters
NODES_LIST=(1 2 4 8 16)
THREADS=1

# Create directories if they do not exist
mkdir -p "$RESULTS_DIR" "$LOGDIR"

# CSV header
echo "nodes,threads,time,max_memory,cpu_percentage" > $RESULTS

for NODES in "${NODES_LIST[@]}"
do
    echo "------------------------------------------------------------"
    echo "Starting test with $NODES nodes and $THREADS threads..."

    # Clean the system before running the test
    echo "Running system pre-cleanup..."
    # ./scripts/clean_system.sh

    # Change the number of threads in the configuration file
    echo "Updating <CpuThreads> to $THREADS in $CONFIG"
    sed -i "s/<CpuThreads>[0-9]\+<\/CpuThreads>/<CpuThreads>${THREADS}<\/CpuThreads>/" "$CONFIG"

    # Build the hosts string
    HOSTS=$(yes localhost | head -n $NODES | paste -sd, -)

    # Change the logfile name to include the number of threads
    LOGFILE="$LOGDIR/multi-node/ubuntu_native_${NODES}nodes_${THREADS}threads.log"
    LOGFILE_RELATIVE="$(realpath --relative-to="$WORKDIR" "$LOGFILE")"

    # Run the program in Docker and save the log
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

echo "------------------------------------------------------------"
echo "All tests have finished. Results in $RESULTS"