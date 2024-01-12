#!/bin/bash

cd "$(dirname "$0")"

stop_package() {
	local package_name=$1

	echo "Stopping $package_name"
	(
		cd "$package_name"
		docker compose stop
	)
}

if [ $# -eq 0 ]; then
	for dir in */; do
		if [ -d "$dir" ]; then
			dir=${dir%/} # Remove trailing slash
			stop_package "$dir"
		fi
	done
else
	stop_package "$1"
fi
