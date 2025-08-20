#!/bin/bash

# Check if WORKDIR was provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <WORKDIR>"
  exit 1
fi

WORKDIR="$1"

# Check if the directory exists
if [ ! -d "$WORKDIR" ]; then
  echo "Directory $WORKDIR does not exist."
  exit 2
fi

# Print info message
echo "------------------------------------------------------------"
echo "Entering directory: $WORKDIR and running make clean and make -j N_FEATURES=3600"
echo "------------------------------------------------------------"

# Change to the specified directory
cd "$WORKDIR" || exit 3

# Run make commands
make clean
make -j N_FEATURES=3600