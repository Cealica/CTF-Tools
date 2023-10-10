#!/bin/bash

# Directory to search for base64 encoded text files
directory_path="."

# Pattern to match base64 encoded text
base64_pattern="^[A-Za-z0-9+/]*={0,3}$"

# Loop through files in the directory and search for base64 encoded text
for file in "$directory_path"/*; do
    if [[ -f "$file" ]]; then
        # Use grep to search for base64 encoded text in the file
        base64_text=$(grep -Eo "$base64_pattern" "$file")
        
        # If base64 encoded text is found, print the filename and base64 text
        if [[ -n "$base64_text" ]]; then
            echo "Base64 encoded text found in file: $file"
            echo "$base64_text"
            echo "--------------------------------------"
        fi
    fi
done
