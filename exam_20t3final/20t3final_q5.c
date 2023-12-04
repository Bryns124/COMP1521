#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>

int main(int argc, char *argv[]) {

    while (argc > 4) {
        fprintf(stderr, "Usage: %s <source file> <destination file>\n", argv[0]);
        return 1;
    }

    struct stat s;
    if (stat(argv[2], &s) != 0) {
        perror(argv[2]);
        exit(1);
    }

    FILE *input_stream = fopen(argv[2],"r");
    if (input_stream == NULL) {
        perror(argv[2]);  // prints why the open failed
        return 1;
    }

    FILE *output_stream = fopen(argv[3], "w");
    if (output_stream == NULL) {
        perror(argv[3]);
        return 1;
    }

    int desired_size = s.st_size - atoi(argv[1]);
    int count = 0;
    while (count < desired_size) {
        int byte = fgetc(input_stream);
        if (byte == EOF) {
            break;
        }
        fputc(byte, output_stream);
        count++;
    }

    fclose(input_stream);  
    fclose(output_stream); 

    return 0;
}