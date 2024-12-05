#!/usr/bin/awk -f

# * Check if there is enough args
BEGIN {
    if (ARGC < 2)
        exit 84
}

# * Get file content
{
    # * Split the file content into two lists
    leftList[NR] = $1
    rightList[NR] = $2
}

function abs(x)
{
    return (x < 0) ? -x : x
}

END {
    # * Check if there is a data to use
    if (NR == 0)
        exit 84

    # * Sort them
    "echo \"" leftList[1] "\" | sort -n" | getline sortedLeft
    "echo \"" rightList[1] "\" | sort -n" | getline sortedRight

    # * Do the sum of all the distance
    totalDistance = 0
    for (i = 1; i <= NR; i++)
        totalDistance += abs(leftList[i] - rightList[i])

    # * Print the result
    print "total distance is " totalDistance

    # * Answer should be 1197984
}
