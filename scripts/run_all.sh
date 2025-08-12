#!/bin/bash
# scripts/run_all.sh

# List of scripts to execute
./scripts/run_scalability_single-node_native.sh
./scripts/run_scalability_single-node_docker.sh
./scripts/run_scalability_multi-node_native.sh

echo "All scripts have finished."
