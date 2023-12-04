#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int main(int argc, char *argv[]) {

    if (argc > 2) {
        return 1;
    }

    FILE* input_stream = fopen(argv[1], "r");
    char ch;

    if (input_stream == NULL) {
        perror(argv[1]);
        return 1;
    }

    if (input_stream == NULL) {
        fclose(input_stream);
        return 1;
    }
    while ((ch = fgetc(input_stream)) != EOF) {
        printf("%c\n", ch);
    }

    fclose(input_stream);

    return 0;
}