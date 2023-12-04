#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>

void process_file(char *pathname);

int main (int argc, char *argv[]) {
    
    int arg = 1;
    while (arg < argc) {
        process_file(argv[arg]);
        arg++;
    }
    return 0;
}

void process_file(char *pathname) {
    FILE *input_stream = fopen(pathname, "r");
    if (input_stream == NULL) {
        perror(pathname);
        exit(1);
    }

    int ascii_count = 0;
    int byte;

    while ((byte = fgetc(input_stream)) != EOF) {
        if (byte < 128) {
            ascii_count++;  
        }
    }

    fclose(input_stream);

    printf("%s contains %d ASCII bytes\n", pathname, ascii_count);

}