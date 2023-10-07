#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 [-a|--all-context] <directory> [search_string]"
  exit 1
fi

all_context=false
search_string=""
directory="."

while [[ $# -gt 0 ]]; do
  case "$1" in
    -a | --all-context)
      all_context=true
      shift
      ;;
    *)
      if [ -d "$1" ]; then
        directory="$1"
      else
        search_string="$1"
      fi
      shift
      ;;
  esac
done

if [ ! -d "$directory" ]; then
  echo "Error: '$directory' is not a valid directory."
  exit 1
fi

if [ "$all_context" = true ]; then
  echo "Scanning all text files for unique lines in '$directory'..."
  find "$directory" -type f -exec grep -v -x -F -f "$directory/findings.txt" {} + | sort -u > unique.txt
  echo "Unique lines saved to unique.txt."
else
  echo "Searching for files matching or containing '$search_string' in '$directory'..."

  # Use 'grep' to search for the string in all files within the directory
  # The '-r' flag makes it search recursively, and '-l' lists only the matching file names
  matching_files=$(grep -rl "$search_string" "$directory")

  if [ -z "$matching_files" ]; then
    echo "No matching files found."
  else
    echo "Matching files:"
    echo "$matching_files" > findings.txt  # Redirect the list of matching files to findings.txt

    # Print the lines containing the search string from matching files
    for file in $matching_files; do
      echo "========== $file ==========" >> findings.txt
      grep "$search_string" "$file" >> findings.txt
    done

    echo "Results saved to findings.txt."
  fi
fi
