#!/bin/bash

# Command for executing
# ./scripts/run_single-node.sh

# Configuration
BASE_DIR="docker-examples/ubuntu-gpu"
RESULTS_DIR="results"
EXEC="bin/hpmoon"
WORKDIR="$BASE_DIR/Hpmoon"
LOGDIR="logs"

# Parameters
PARAMS="$BASE_DIR $RESULTS_DIR $EXEC $WORKDIR $LOGDIR"

# Script list
SCRIPTS=(
    "./scripts/run_scalability_single-node_native.sh"
    # "./scripts/run_scalability_single-node_container.sh"
    "./scripts/run_scalability_multi-node_native.sh"
    # "./scripts/run_scalability_multi-node_container.sh"
    "./scripts/run_scalability_multi-node_sweep-threads_native.sh"
    # "./scripts/run_scalability_multi-node_sweep-threads_container.sh"
    "./scripts/run_scalability_multi-node_sweep-threads_no-limit_native.sh"
)

for script in "${SCRIPTS[@]}"; do
    $script $PARAMS
done

echo "All scripts have finished."