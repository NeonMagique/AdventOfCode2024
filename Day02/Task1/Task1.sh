#!/usr/bin/bash

# * Check if the line is safe
check_numbers()
{
    type="NONE"
    for ((i = 0; i < ${#numbers[@]} - 1; i++)); do
        difference=$((numbers[i] - numbers[i + 1]))
        if ((difference > 0 && difference <= 3)); then
            if [ "$type" = "INCREASE" ]; then
                return 1
            else
                type="DECREASE"
                continue
            fi
        fi
        if ((difference < 0 && difference >= -3)); then
            if [ "$type" = "DECREASE" ]; then
                return 1
            else
                type="INCREASE"
                continue
            fi
        fi
        return 1
    done
    return 0
}

safeReportCount=0

# * Get file content
while IFS= read -r line; do
    numbers=($line)
    check_numbers
    if [ $? -eq 0 ]; then
        ((safeReportCount++))
        continue
    fi
done < input.txt

# * Print the result
echo "$safeReportCount"

# * Answer should be 379
