#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {

    while (argc > 4) {
        return 1;
    }

    FILE *output_stream = fopen(argv[1], "a");

    if (output_stream == NULL) {
        perror("output_stream");
        return 1;
    }

    int range_first = atoi(argv[2]);
    int range_last = atoi(argv[3]);

    while (range_first <= range_last) {
        fprintf(output_stream, "%d\n", range_first);
        range_first++;
    }

    return 0;
}