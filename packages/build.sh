#!/bin/bash

cd "$(dirname "$0")"

# Check if an argument is provided
if [ $# -eq 0 ]; then
	echo "No argument provided. Please provide a package name."
	exit 1
fi

PACKAGE_NAME=$1

# Build the package
(cd ../../"$PACKAGE_NAME" && docker compose build)

cd ..

# Build the dev environment with the provided package name
PACKAGE=robotics-deployment:"$PACKAGE_NAME" &&
	docker build -t ${PACKAGE}-dev --build-arg PACKAGE=${PACKAGE} -f Dockerfile .
