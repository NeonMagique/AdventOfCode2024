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

regex_t get_regex()
{
    const char *pattern = "mul\\(([0-9]+),([0-9]+)\\)";
    regex_t regex;

    if (regcomp(&regex, pattern, REG_EXTENDED) != 0) {
        fprintf(stderr, "Could not compile regex\n");
        exit(EXIT_FAILURE);
    }
    return regex;
}

int get_one_mul(regex_t *regex, const char **cursor, bool tmp)
{
    regmatch_t matches[3] = {};
    static int mul_find = 0; // * Could have been a global var but I don't like it...

    if (tmp == true) {
        dprintf(1, "You found %d mul\n", mul_find);
        return 0;
    }
    if (regexec(regex, *cursor, 3, matches, 0) == 0) {
        mul_find++;
        char num1[16], num2[16];
        int start1 = matches[1].rm_so;
        int end1 = matches[1].rm_eo;
        int start2 = matches[2].rm_so;
        int end2 = matches[2].rm_eo;

        strncpy(num1, (*cursor) + start1, end1 - start1);
        num1[end1 - start1] = '\0';
        strncpy(num2, (*cursor) + start2, end2 - start2);
        num2[end2 - start2] = '\0';

        int a = atoi(num1);
        int b = atoi(num2);

        int result = a * b;

        (*cursor) += matches[0].rm_eo;
        return a * b;
    }
    return -1;
}
int check_one_line(char *line, regex_t *regex)
{
    int status = 0;
    int total_line = 0;

    const char *cursor = line;
    while (1) {
        status = get_one_mul(regex, &cursor, false);
        if (status == -1)
            break;
        else
            total_line += status;
    }
    return total_line;
}

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

int main()
{
    int total_value = 0;
    read_file(&total_value);
    dprintf(1, "There is in total %d\n", total_value);
    get_one_mul(NULL, NULL, true);
}

// * To check in VsCode if it's the good value
// * mul\([0-9]+,[0-9]+\)