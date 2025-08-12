#!/bin/bash
# scripts/clean_system.sh

echo "Cleaning page cache..."
sudo sync
sudo sysctl -w vm.drop_caches=3