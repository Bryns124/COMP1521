#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {

    const char forty_two[2] = {"42"};
    if (getenv(argv[1]) == NULL) {
        setenv(argv[1], forty_two, 1);
    }
    
    if (getenv(argv[2]) == NULL) {
        setenv(argv[2], forty_two, 1);
    }
    
    int first_int = atoi(getenv(argv[1]));
    int second_int = atoi(getenv(argv[2]));
    int difference = abs(first_int - second_int);

    if (difference < 10) {
        printf("1\n");
    } else {
        printf("0\n");
    }
}