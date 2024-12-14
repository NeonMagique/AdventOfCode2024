#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'

if [ -z "$1" ] || [ -z "$2" ]; then
  echo -e "${RED}Usage: $0 <day> <extension>${RESET}"
  exit 1
fi

day="$1"
extension="$2"

echo -e "${GREEN}Creating directories for $day/Task1 and $day/Task2...${RESET}"
mkdir -p "$day/Task1"
mkdir -p "$day/Task2"

echo -e "${GREEN}Creating Task1/Task1$extension and Task2/Task2$extension...${RESET}"
touch "$day/Task1/Task1$extension"
touch "$day/Task2/Task2$extension"

echo -e "${GREEN}Creating input.txt in $day...${RESET}"
input_file="$day/input.txt"
day_number=$(echo "$day" | sed 's/[^0-9]*//g')
token=$(grep -oP '^AOC_TOKEN=\K.*' .env)
echo "Here is your token: ${token}"
curl -s "https://adventofcode.com/2024/day/${day_number}/input" -H "cookie: session=${token}" -o "$input_file"

echo -e "${GREEN}Creating and initializing execute.md...${RESET}"
execute_file="$day/execute.md"
echo "# How to execute ?" > "$execute_file"

echo -e "${GREEN}Success: Files and directories for $day created.${RESET}"
