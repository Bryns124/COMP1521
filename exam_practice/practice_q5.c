#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {

    char *first_environment = getenv(argv[1]);
    char *second_environment = getenv(argv[2]);

    if (strcmp(first_environment, second_environment) == 0) {
        printf("1\n");
    }
    else {
        printf("0\n");
    }
    return 0;
}