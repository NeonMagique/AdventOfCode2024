#!/usr/bin/env python3

import sys

# * Check if there is enough args
if len(sys.argv) < 2:
    exit(84)

# * Get file content
with open(sys.argv[1], 'r') as file:
    data = [tuple(map(int, line.strip().split())) for line in file]

# * Check if there is a data to use
if len(data) == 0:
    exit(84)

# * Split the file content into two lists
leftList = [pair[0] for pair in data]
rightList = [pair[1] for pair in data]

# * Sort them
leftList.sort()
rightList.sort()

# * Do the sum of all the distance
totalDistance = sum(abs(left - right) for left, right in zip(leftList, rightList))

# * Print the result
print(f"total distance is {totalDistance}")

# * Answer should be 1197984
