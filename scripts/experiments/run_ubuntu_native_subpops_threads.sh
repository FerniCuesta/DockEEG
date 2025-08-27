#!/bin/bash

# Configuration
BASE_DIR="${1:-docker-examples/ubuntu-no-gpu}"
WORKDIR="${2:-$BASE_DIR/Hpmoon}"
RESULTS_DIR="${3:-results}"
EXEC="${4:-bin/hpmoon}"
LOGDIR="${5:-logs}"

CONFIG="$WORKDIR/config.xml"

# Test parameters
NODES=1
THREADS_LIST=(1 2 4 8 16)
SUBPOPS_LIST=(1 2 4 8 16)

# Create directories if they do not exist
mkdir -p "$RESULTS_DIR" "$LOGDIR"

for SUBPOPS in "${SUBPOPS_LIST[@]}"
do
    # Update NSubpopulations in config.xml
    echo "Updating <NSubpopulations> to $SUBPOPS in $CONFIG"
    sed -i "s/<NSubpopulations>[0-9]\+<\/NSubpopulations>/<NSubpopulations>${SUBPOPS}<\/NSubpopulations>/" "$CONFIG"

    # CSV header and results file for this subpopulation
    RESULTS="$RESULTS_DIR/experiments/ubuntu_native_${SUBPOPS}subpops.csv"
    echo "nodes,threads,subpopulations,time,max_memory,cpu_percentage" > $RESULTS

    for THREADS in "${THREADS_LIST[@]}"
    do
        echo "------------------------------------------------------------"
        echo "Starting test with $THREADS threads and $SUBPOPS subpopulations..."
        echo "Running system cleanup..."

        # Clean the system before running the test
        # ./scripts/clean_system.sh

        # Change the number of threads in the configuration file
        echo "Updating <CpuThreads> to $THREADS in $CONFIG"
        sed -i "s/<CpuThreads>[0-9]\+<\/CpuThreads>/<CpuThreads>${THREADS}<\/CpuThreads>/" "$CONFIG"

        # Change the logfile name to include the number of threads and subpopulations
        LOGFILE="$LOGDIR/experiments/ubuntu_native_${SUBPOPS}subpops_${THREADS}threads.log"
        LOGFILE_RELATIVE="$(realpath --relative-to="$WORKDIR" "$LOGFILE")"

        # Run the program
        echo "Running the program and saving log to $LOGFILE"
        (
            cd "$WORKDIR"
            /usr/bin/time -v mpirun --bind-to none --allow-run-as-root --map-by node --host localhost ./$EXEC -conf config.xml > "$LOGFILE_RELATIVE" 2>&1
        )

        # Extract metrics from the log file
        echo "Extracting metrics from $LOGFILE"
        real_time=$(grep "Elapsed (wall clock) time" "$LOGFILE" | awk '{print $8}')
        max_memory=$(grep "Maximum resident set size" "$LOGFILE" | awk '{print $6}')
        cpu_percentage=$(grep "Percent of CPU this job got" "$LOGFILE" | awk -F: '{gsub(/%/,""); print $2}' | xargs)

        # Log the results
        echo "$NODES,$THREADS,$SUBPOPS,$real_time,$max_memory,$cpu_percentage" >> $RESULTS
        
        echo "Test with $THREADS threads and $SUBPOPS subpopulations finished."
    done
done

echo "------------------------------------------------------------"
echo "All tests have finished. Results in $RESULTS_DIR"