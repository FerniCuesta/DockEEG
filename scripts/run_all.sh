#!/bin/bash

# Command for executing
# ./scripts/run_single-node.sh

# Configuration
BASE_DIR="docker-examples/ubuntu-no-gpu"
WORKDIR="$BASE_DIR/Hpmoon"
RESULTS_DIR="results"
EXEC="bin/hpmoon"
LOGDIR="logs"

# Parameters
PARAMS="$BASE_DIR $WORKDIR $RESULTS_DIR $EXEC $LOGDIR"

# Script list
SCRIPTS=(
    "./scripts/single-node/run_ubuntu_native.sh"
    # "./scripts/single-node/run_ubuntu_container.sh"
    # "./scripts/single-node/run_cluster_container.sh"
    # "./scripts/multi-node/run_ubuntu_native.sh"
    # "./scripts/multi-node/run_ubuntu_container.sh"
    # "./scripts/sweep-threads/run_ubuntu_native.sh"
    # "./scripts/sweep-threads/run_ubuntu_container.sh"
    # "./scripts/sweep-threads/run_no-limit_ubuntu_native.sh"
)

for script in "${SCRIPTS[@]}"; do
    $script $PARAMS
done

echo "All scripts have finished."