#!/bin/bash

cd "$(dirname "$0")"

build_package() {
	local package_name=$1

	echo "Building project package: $package_name"
	(
		cd ../../"$package_name"
		docker compose build
	)

	echo "Building dev environment for package: $package_name"
	(
		cd ..
		local package=robotics-deployment:"$package_name"
		docker build -t "${package}-dev" --build-arg PACKAGE="${package}" -f Dockerfile .
	)
}

if [ $# -eq 0 ]; then
	for dir in */; do
		if [ -d "$dir" ]; then
			dir=${dir%/} # Remove trailing slash
			build_package "$dir"
		fi
	done
else
	build_package "$1"
fi
