#!/bin/bash
# scripts/clean_system.sh

echo "Limpiando caché de página..."
sudo sync
sudo sysctl -w vm.drop_caches=3