#!/bin/bash

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
    "./scripts/experiments/run_limit_ubuntu_native.sh"
    "./scripts/experiments/run_no-limit_ubuntu_native.sh"
)

# Compile program
./scripts/utils/build_hpmoon.sh "$WORKDIR"

# Execute script list
for script in "${SCRIPTS[@]}"; do
    $script $PARAMS
done

echo "All scripts have finished."