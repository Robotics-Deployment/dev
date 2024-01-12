#!/bin/bash

cd "$(dirname "$0")"

down_package() {
	local package_name=$1

	echo "Downing $package_name"
	(
		cd "$package_name"
		docker compose down
	)
}

if [ $# -eq 0 ]; then
	for dir in */; do
		if [ -d "$dir" ]; then
			dir=${dir%/} # Remove trailing slash
			down_package "$dir"
		fi
	done
else
	down_package "$1"
fi
