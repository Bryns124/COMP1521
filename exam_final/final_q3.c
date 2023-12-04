// COMP1521 21T2 ... final exam, question 3

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

void
cp (char *path_from, char *path_to)
{
	FILE *input = fopen(path_from, "r");
	if (input == NULL) {
        perror(path_from);
        exit(1);
    }

	FILE *output = fopen(path_to, "w");
    if (output == NULL) {
        perror(path_to);
        exit(1);
    }

	int c = fgetc(input);
    while (c != EOF) {
        fputc(c, output);
        c = fgetc(input);
    }

	fclose(input);
    fclose(output);
}

