#!/usr/bin/env python3

from collections import Counter
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
right_counts = dict(Counter([pair[1] for pair in data]))

# * Do the sum of all similarity score
smiliarityScore = sum((left * right_counts.get(left, 0) for left in leftList))

# * Print the result
print(f"total similarity score is {smiliarityScore}")

# * Answer should be 23387399