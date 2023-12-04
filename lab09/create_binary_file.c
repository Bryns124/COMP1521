#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    
    FILE *output_stream = fopen(argv[1], "w+");
    
    if (output_stream == NULL) {
        perror(argv[1]);
        return 1;
    }
    
    int counter = 2;
    while (counter < argc) {
        int i = atoi(argv[counter]);
        fputc(i, output_stream);
        counter++;
    }
    
    fclose(output_stream);
    return 0;
}
