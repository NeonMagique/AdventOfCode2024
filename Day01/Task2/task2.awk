#!/usr/bin/awk -f

# * Check if there is enough args
BEGIN {
    if (ARGC < 2) {
        exit 84
    }
}

# * Get file content
{
    # * Split the file content into two lists
    leftList[NR] = $1
    rightCounts[$2]++
}

END {
    # * Check if there is a data to use
    if (NR == 0)
        exit 84

    # * Calculate the similarity score
    similarityScore = 0
    for (i = 1; i <= NR; i++)
        similarityScore += leftList[i] * rightCounts[leftList[i]]

    # * Print the result
    print "total similarity score is " similarityScore

    # * Answer should be 23387399
}
