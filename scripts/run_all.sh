#!/bin/bash

# Command for executing
# ./scripts/run_single-node.sh

# Configuration
BASE_DIR="docker-examples/ubuntu-gpu"
WORKDIR="$BASE_DIR/Hpmoon"
RESULTS_DIR="results"
EXEC="bin/hpmoon"
LOGDIR="logs"

# Parameters
PARAMS="$BASE_DIR $RESULTS_DIR $EXEC $WORKDIR $LOGDIR"

# Script list
SCRIPTS=(
    "./scripts/single-node/run_single-node_native.sh"
    "./scripts/single-node/run_single-node_container.sh"
    "./scripts/multi-node/run_multi-node_native.sh"
    "./scripts/multi-node/run_multi-node_container.sh"
    "./scripts/multi-node/run_sweep-threads_native.sh"
    "./scripts/multi-node/run_sweep-threads_container.sh"
    "./scripts/multi-node/run_sweep-threads_no-limit_native.sh"
)

for script in "${SCRIPTS[@]}"; do
    $script $PARAMS
done

echo "All scripts have finished."