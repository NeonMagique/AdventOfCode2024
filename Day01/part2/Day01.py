#!/usr/bin/env python3

from collections import Counter

# * Get file content
with open('input.txt', 'r') as file:
    data = [tuple(map(int, line.strip().split())) for line in file]

# * Split the file content into two lists
leftList = [pair[0] for pair in data]
right_counts = dict(Counter([pair[1] for pair in data]))

# * Do the sum of all similarity score
smiliarityScore = sum((left * right_counts.get(left, 0) for left in leftList))

# * Print the result
print(f"total similarity score is {smiliarityScore}")

# * Answer should be 23387399