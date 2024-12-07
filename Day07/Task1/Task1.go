package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func readFile(filename string) ([]string) {
    var lines []string

    // * Open the file
    file, err := os.Open(filename)
    if err != nil {
        os.Exit(84)
    }
    defer file.Close()
    // * Get the content
    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        lines = append(lines, scanner.Text())
    }
    if err := scanner.Err(); err != nil {
        os.Exit(84)
    }
    return lines
}

func convertStringsToInts(numbers []string) []int {
	var list []int
	for _, numStr := range numbers {
		num, err := strconv.Atoi(numStr)
		if err != nil {
            os.Exit(84)
		}
		list = append(list, num)
	}
	return list
}

func pow(base, exp int) int {
	result := 1
	for exp > 0 {
		result *= base
		exp--
	}
	return result
}

// * Only for optimisation
var possibleCombinaison = make(map[int][]string)

func createCombinaisonFor(length int) []string {
	var result []string
	operators := []string{"+", "*"}
	totalCombinations := pow(2, length)

	for i := 0; i < totalCombinations; i++ {
		var group strings.Builder
		num := i
		for j := 0; j < length; j++ {
			group.WriteString(operators[num % 2])
			num /= 2
		}
		result = append(result, group.String())
	}
	possibleCombinaison[length] = result
	return result
}

func isEquationPossible(result int, numbers []int) bool {
	length := len(numbers) - 1

	combinations, exists := possibleCombinaison[length]
	if !exists {
		combinations = createCombinaisonFor(length)
	}
	for _, combination := range combinations {
        tmpResult := numbers[0]
        for index, action := range combination {
            if (action == '*') {
                tmpResult *= numbers[index + 1]
            }
            if (action == '+') {
                tmpResult += numbers[index + 1]
            }
            // * Only for optimisation
            if (tmpResult > result) {
                break;
            }
        }
        if (tmpResult == result) {
            return true
        }
	}
	return false
}

func main() {
	args := os.Args
    total := 0

	if len(args) < 2 {
        os.Exit(84)
    }

	content := readFile(args[1])
    for _, line := range content {
		parts := strings.Split(line, ":")
		if len(parts) != 2 {
			fmt.Fprintf(os.Stderr, "Format invalide : %s\n", line)
			continue
		}
        result, _ := strconv.Atoi(parts[0])
        numbers := convertStringsToInts(strings.Fields(parts[1]))
        if isEquationPossible(result, numbers) {
            total +=  result
        }
	}
    // * Print the result
    fmt.Printf("Here is the total: %d\n", total)
    // * Answer should be 1399219271639
}
