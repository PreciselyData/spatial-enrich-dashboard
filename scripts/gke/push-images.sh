#!/bin/bash
set -e

if [ -z "$1" ]; then
  echo "Registry URL does not specify."
  exit 1
fi

if ! [ -z "$2" ]; then
  echo ">>>load $2 image"
  docker load -i $2.tar
  docker tag $2:latest $1/$2:latest
  docker push $1/$2:latest
  echo -e "<<<image loaded\n"
  exit 0
fi

echo ">>>load spatial-enrich-dashboard image"
docker load -i spatial-enrich-dashboard.tar
docker tag spatial-enrich-dashboard:latest $1/spatial-enrich-dashboard:latest
docker push $1/spatial-enrich-dashboard:latest
echo -e "<<<image loaded\n"
echo "Images pushed to artifact registry successfully."
