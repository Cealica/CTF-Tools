#!/bin/bash

custom_name=""
numbered_only=true

while [[ $# -gt 0 ]]; do
  case "$1" in
    --custom | -c)
      custom_name="$2"
      numbered_only=false
      shift 2
      ;;
    *)
      break
      ;;
  esac
done

if [ $# -ne 1 ]; then
  echo "Usage: $0 [-c <custom_name>] <directory>"
  exit 1
fi

directory="$1"
count=1

cd "$directory" || exit 1

for file in *; do
  if [ -f "$file" ]; then
    extension="${file##*.}"
    if [ -n "$custom_name" ]; then
      new_name="${custom_name}_$count.$extension"
    elif ! $numbered_only; then
      new_name="$count.$extension"
    else
      continue
    fi
    mv "$file" "$new_name"
    ((count++))
  fi
done
