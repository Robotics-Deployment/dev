#!/bin/bash
# This is to install nvim, alacritty and catpuccin theme.

cd "$(dirname "$0")"

# NVIM
dest_dir="$HOME/.config/nvim"

if [ ! -d "$dest_dir" ]; then
	echo "Nvim not installed. Please install nvim first."
	exit 1
fi

cp -r ./nvim/* "$dest_dir/"
echo "Nvim config installed!"

# ALACRITTY
dest_dir="$HOME/.config/alacritty"

if [ ! -d "$dest_dir" ]; then
	echo "Alacritty not installed. Skipping..."
fi

cp -r ./alacritty/* "$dest_dir/"
echo "Alacritty config installed!"

# Check if FiraCode is installed
font_pattern="Fira Code.*Retina"

if ! fc-list | grep -q "$font_pattern"; then
	echo "Fira Code not installed. Please install Fira Code if you'd like."
	echo "sudo apt install fonts-firacode"
else
	echo "Fira Code installed!"
fi

echo "Done!"
