#!/bin/bash

# Prune all unused Docker objects
docker system prune --all --force

# Remove the cdk.out directory
rm -rf cdk.out/

# Remove all files in the /tmp directory
rm -rf /tmp/*

# Print a message indicating the cleanup is done
echo "Cleanup complete."
