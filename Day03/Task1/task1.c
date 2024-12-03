/*
** EPITECH PROJECT, 2024
** AdventOfCode2024
** File description:
** Task1
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <regex.h>
#include <stdbool.h>

/// @brief This function gonna create the pattern of the regex we gonna use for the problem
/// @return the regex we create
regex_t get_regex(void)
{
    const char *pattern = "mul\\(([0-9]+),([0-9]+)\\)";
    regex_t regex;

    if (regcomp(&regex, pattern, REG_EXTENDED) != 0) {
        fprintf(stderr, "Could not compile regex\n");
        exit(EXIT_FAILURE);
    }
    return regex;
}

/// @brief This function gonna calculate the mul pattern
/// @param cursor represent where we are currently on the line
/// @param matches represent the struct that gonna contain the information to split the pattern
/// @param debug represent a toggle using for debug to print the total mul pattern find at this point
/// @return the result of the mul
int calculate_one_mul(const char **cursor, regmatch_t matches[3], bool debug)
{
    char num[2][16] = {};
    static int mul_find = 0; // * Could have been a global var but I don't like it...

    // ? Only use for debug
    if (debug == true) {
        // * Number should be 671
        dprintf(1, "You found %d mul\n", mul_find);
        return 0;
    }
    // ?
    mul_find++;
    strncpy(num[0], (*cursor) + matches[1].rm_so, matches[1].rm_eo - matches[1].rm_so);
    num[0][matches[1].rm_eo - matches[1].rm_so] = '\0';
    strncpy(num[1], (*cursor) + matches[2].rm_so, matches[2].rm_eo - matches[2].rm_so);
    num[1][matches[2].rm_eo - matches[2].rm_so] = '\0';

    (*cursor) += matches[0].rm_eo;
    return atoi(num[0]) * atoi(num[1]);
}

/// @brief This function will try to get one occurence of the mul pattern "mul(a, b)" and calculate it
/// @param regex represent the regex to check the mul pattern
/// @param cursor represent where we are currently on the line
/// @return -1 if failed or the result of the mul if success
int get_one_mul(regex_t *regex, const char **cursor)
{
    regmatch_t matches[3] = {};

    if (regexec(regex, *cursor, 3, matches, 0) == 0) {
        return calculate_one_mul(cursor, matches, false);
    }
    return -1;
}

/// @brief This function gonna check one line a try to execute every mul it find
/// @param line represent the line we are checking
/// @param regex represent the regex to check the pattern of the mul
/// @return the result of all the mul we did on this line
int check_one_line(char *line, regex_t *regex)
{
    int status = 0;
    int total_line = 0;

    const char *cursor = line;
    while (1) {
        status = get_one_mul(regex, &cursor);
        if (status == -1)
            break;
        else
            total_line += status;
    }
    return total_line;
}

/// @brief This function will read line by line the content of 'input.txt' file and call the check function
/// @param total_value represent the total of what we gonna calculate on every line
void read_file(int *total_value)
{
    FILE *fp = NULL;
    char *line = NULL;
    size_t len = 0;
    ssize_t read = 0;
    regex_t regex = get_regex();

    fp = fopen("input.txt", "r");
    if (fp == NULL) {
        perror("Failed: ");
        exit(EXIT_FAILURE);
    }
    while ((read = getline(&line, &len, fp)) != -1)
        (*total_value) += check_one_line(line, &regex);
    regfree(&regex);
    free(line);
    fclose(fp);
}

int main(void)
{
    int total_value = 0;

    read_file(&total_value);
    dprintf(1, "There is in total %d\n", total_value);
    calculate_one_mul(NULL, NULL, true);
}

// * Answer should be 166905464

// * To check in VsCode if it's the good value
// * mul\([0-9]+,[0-9]+\)