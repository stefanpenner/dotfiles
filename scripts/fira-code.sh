#!/bin/bash

# Define variables
FONT_DIR="$HOME/Library/Fonts"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
FONT_ZIP="/tmp/FiraCode.zip"

# Helper function for error handling
function error {
  echo "Error: $1"
  exit 1
}

# Create fonts directory if it doesn't exist
echo "Ensuring font directory exists..."
mkdir -p "$FONT_DIR" || error "Failed to ensure font directory exists."

# Download the font zip file
echo "Downloading Fira Code Nerd Font..."
curl -fLo "$FONT_ZIP" "$FONT_URL" || error "Failed to download font from $FONT_URL."

# Extract the font files
echo "Extracting Fira Code Nerd Font..."
unzip -o "$FONT_ZIP" -d "$FONT_DIR" || error "Failed to extract the font zip file."
rm "$FONT_ZIP" || error "Failed to remove the zip file."

# Notify the user
echo "Fira Code Nerd Font installed successfully! You may need to restart your applications to see the new font."
