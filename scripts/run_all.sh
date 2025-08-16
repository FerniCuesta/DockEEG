#!/bin/bash
# scripts/run_all.sh

# List of scripts to execute
./scripts/run_scalability_single-node_native.sh
./scripts/run_scalability_single-node_container.sh
./scripts/run_scalability_multi-node_native.sh
./scripts/run_scalability_multi-node_container.sh
./scripts/run_scalability_multi-node_sweep-threads_native.sh
./scripts/run_scalability_multi-node_sweep-threads_container.sh

echo "All scripts have finished."
