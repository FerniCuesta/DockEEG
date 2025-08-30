#!/bin/bash

# Configuration
BASE_DIR_NO_GPU="docker-examples/ubuntu-no-gpu"
BASE_DIR_GPU="docker-examples/ubuntu-gpu"
RESULTS_DIR="results"
EXEC="bin/hpmoon"
LOGDIR="logs"

# Script list with associated BASE_DIR
SCRIPTS_AND_BASEDIRS=(
    # "./scripts/thread-sweep/run_ubuntu_native.sh:$BASE_DIR_NO_GPU"
    # "./scripts/thread-sweep/run_ubuntu_container.sh:$BASE_DIR_NO_GPU"
    "./scripts/thread-sweep/run_ubuntu_gpu_native.sh:$BASE_DIR_GPU"
    "./scripts/thread-sweep/run_ubuntu_gpu_container.sh:$BASE_DIR_GPU"
)

# Compile program
./scripts/utils/build_hpmoon.sh "$BASE_DIR_NO_GPU/Hpmoon"
./scripts/utils/build_hpmoon.sh "$BASE_DIR_GPU/Hpmoon"

# Execute script list
for entry in "${SCRIPTS_AND_BASEDIRS[@]}"; do
    script="${entry%%:*}"
    BASE_DIR="${entry##*:}"
    WORKDIR="$BASE_DIR/Hpmoon"
    PARAMS="$BASE_DIR $WORKDIR $RESULTS_DIR $EXEC $LOGDIR"
    $script $PARAMS
done

echo "All scripts have finished."