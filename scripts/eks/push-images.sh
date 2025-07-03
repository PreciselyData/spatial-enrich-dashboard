#!/bin/bash
set -e

if [ -z "$1" ]; then
  echo "Error: Registry URL not specified."
  exit 1
fi

REGISTRY="$1"

load_and_push() {
  local tar_file="$1"
  if [ ! -f "$tar_file" ]; then
    echo "Error: File '$tar_file' does not exist."
    exit 1
  fi

  echo ">>> Loading image from $tar_file"
  loaded_image=$(docker load -i "$tar_file" | awk -F': ' '/Loaded image:/ {print $2}')
  
  if [ -z "$loaded_image" ]; then
    echo "Error: Could not determine loaded image name."
    exit 1
  fi

  echo "Loaded image is: $loaded_image"
  # Tag with the registry URL
  docker tag "$loaded_image" "${REGISTRY}/spatial-enrich-dashboard:latest"
  docker push "${REGISTRY}/spatial-enrich-dashboard:latest"
  echo "<<< Image '${loaded_image}' pushed to ${REGISTRY}"
}

if [ -n "$2" ]; then
  load_and_push "${2}.tar"
  exit 0
fi

load_and_push "spatial-enrich-dashboard.tar"
echo "Images pushed to artifact registry successfully."