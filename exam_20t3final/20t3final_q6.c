#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

void process_file(char *pathname);
int get_n_bit_set(uint8_t byte);

int main(int argc, char *argv[]) {
    for (int arg = 1; arg < argc; arg++) {
        process_file(argv[arg]);
    }
    return 0;
}

void process_file(char *pathname) {
    FILE *stream = fopen(pathname, "r");
    if (stream == NULL) {
        perror(pathname);
        exit(1);
    }

    ssize_t bit_count = 0;
    int byte;
    while ((byte = fgetc(stream)) != EOF) {
        bit_count += get_n_bit_set(byte);
     }

    fclose(stream);
    printf("%s has %zd bits set\n",  pathname, bit_count);
}

int get_n_bit_set(uint8_t byte) {
    int bits_set = 0;
    for (int i = 0; i < 8; i++) {
        bits_set += byte & 0x1;
        byte >>=1;
    }
    return bits_set;
}