#include <stdio.h>
#include <stdlib.h>

#define SERIES_MAX 46

int fibonacci(int input_num);

int main(void) {
    int input_num;
    int finish = 1;
    int next;
    while (scanf("%d", &input_num) == 1) {
        if (finish == 1) {
            next = fibonacci(input_num);
            printf("%d\n", next);
        }
    }
    return EXIT_SUCCESS;
}

int fibonacci(int input_num) {
    if (input_num == 0) {
        return 0;
    }
    else if (input_num == 1) {
        return 1;
    }
    else if (input_num > 1) {
    }
    return (fibonacci(input_num - 2) + fibonacci(input_num - 1));
}
