#!/bin/bash

# define variables
font_dir="$home/library/fonts"
font_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/firacode.zip"
font_zip="/tmp/firacode.zip"

# helper function for error handling
function error {
  echo "error: $1"
  exit 1
}

# create fonts directory if it doesn't exist
echo "ensuring font directory exists..."
mkdir -p "$font_dir" || error "failed to ensure font directory exists."

# download the font zip file
echo "downloading fira code nerd font..."
curl -flo "$font_zip" "$font_url" || error "failed to download font from $font_url."

# extract the font files
echo "extracting fira code nerd font..."
unzip -o "$font_zip" -d "$font_dir" || error "failed to extract the font zip file."
rm "$font_zip" || error "failed to remove the zip file."

# notify the user
echo "fira code nerd font installed successfully! you may need to restart your applications to see the new font."
