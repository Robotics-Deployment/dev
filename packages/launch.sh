#!/bin/bash

cd "$(dirname "$0")"

# Check if an argument is provided
if [ $# -eq 0 ]; then
	echo "No argument provided. Please provide a package name."
	exit 1
fi

PACKAGE_NAME=$1
cd $PACKAGE_NAME

echo "Lauching $PACKAGE_NAME"
docker compose up -d

echo "Attaching to $PACKAGE_NAME"
docker exec -it rd$PACKAGE_NAME bash
