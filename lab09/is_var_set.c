#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>

int main (int argc, char *argv[]) {

    char *env_val = getenv(argv[1]);

    if (env_val == NULL || env_val[0] == '\0') {
        printf("0\n");
    }
    else {
        printf("1\n");
    }
}