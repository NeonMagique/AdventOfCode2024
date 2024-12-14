#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <day>"
  exit 1
fi

day="$1"
mkdir -p "$day"
mkdir -p "$day/Task1"
mkdir -p "$day/Task2"

input_file="$day/input.txt"
touch "$input_file"

execute_file="$day/execute.md"
echo "# How to execute ?" > "$execute_file"

echo "Success"
