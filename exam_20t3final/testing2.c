#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {

    int first_int = atoi(getenv(argv[1]));
    int second_int = atoi(getenv(argv[2]));
    int difference = abs(first_int - second_int);

    printf("%d\n", first_int);
    printf("%d\n", second_int);
    printf("%d\n", difference);

    return 0;
}