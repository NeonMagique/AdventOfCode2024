/*
** EPITECH PROJECT, 2024
** AdventOfCode2024
** File description:
** Task2
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <regex.h>

/// @brief This function will check if it's match the mul pattern and calculate the result only if the bool 'calculate' is true
/// @param str represent the string where we check the pattern
/// @param result represent the total we have calculate on this line currently
/// @param calculate represent if we are allow to calculate or not the mul
/// @return
int match_mul(const char *str, int *result, bool calculate)
{
    int first_nb = 0;
    int second_nb = 0;
    char *end = NULL;
    const char *start = NULL;

    if (strncmp(str, "mul(", 4) == 0) {
        start = str + 4;
        first_nb = strtol(start, &end, 10);
        if (*end != ',')
            return 0;
        second_nb = strtol(end + 1, &end, 10);
        if (*end != ')')
            return 0;
        str = end;
        if (calculate)
            *result += first_nb * second_nb;
        return 1;
    }
    return 0;
}

/// @brief This function gonna check each pattern on the line
/// @param line represent the line we are checking
/// @param calculate represent if we can do the mul action or not
int check_one_line(char *line, bool *calculate)
{
    int total_line = 0;
    const char *cursor = line;

    while (*cursor) {
        if (strncmp(cursor, "don't()", 7) == 0) {
            cursor += 7;
            (*calculate) = false;
            continue;
        }
        if (strncmp(cursor, "do()", 4) == 0) {
            cursor += 4;
            (*calculate) = true;
            continue;
        }
        if (match_mul(cursor, &total_line, *calculate)) {
            while (*cursor && *cursor != ')')
                cursor++;
            if (*cursor == ')')
                cursor++;
            continue;
        }
        cursor++;
    }
    return total_line;
}

/// @brief This function will read the file "input.txt" and check line by line if it's find pattern like :
/// don't() / do() / mul(a, b)
/// @param filename represent the name of the file we gonna read
/// @param total_value represent the total of all the value we get from each line
void read_file(const char *filename, int *total_value)
{
    FILE *fp = NULL;
    char *line = NULL;
    size_t len = 0;
    ssize_t read = 0;
    bool calculate = true;

    fp = fopen("input.txt", "r");
    if (fp == NULL) {
        perror("Failed: ");
        exit(EXIT_FAILURE);
    }
    while ((read = getline(&line, &len, fp)) != -1)
        (*total_value) += check_one_line(line, &calculate);
    free(line);
    fclose(fp);
}

int main(int argc, char **argv)
{
    int total_value = 0;

    if (argc < 2)
        return 84;
    read_file(argv[1], &total_value);
    dprintf(1, "There is in total %d\n", total_value);
}

// * Answer should be 72948684