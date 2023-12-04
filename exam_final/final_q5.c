// COMP1521 21T2 ... final exam, question 5

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

int get_byte(FILE *file) {
    int byte = fgetc(file);
    return byte;
}

void
print_utf8_count (FILE *file)
{
	unsigned long amount_1_byte = 0;
	unsigned long amount_2_byte = 0;
	unsigned long amount_3_byte = 0;
	unsigned long amount_4_byte = 0;

	ssize_t utf8_count = 0;
    int byte1;
    while ((byte1 = fgetc(file)) != EOF) {
        if((byte1 & 0xC0) != 0x80) {
            amount_1_byte++;
        }

        get_byte(file);

        if ((byte1 & 0xC8) != 0xC0) {
            amount_2_byte++;
        }

        get_byte(file);

        if ((byte1 & 0xF0) != 0xE0) {
            amount_3_byte++;
        }

        get_byte(file);

        if ((byte1 & 0xF8) != 0xF0) {
            amount_4_byte++;
        }
		utf8_count++;
    }

    fclose(file);

	printf("1-byte UTF-8 characters: %lu\n", amount_1_byte);
	printf("2-byte UTF-8 characters: %lu\n", amount_2_byte);
	printf("3-byte UTF-8 characters: %lu\n", amount_3_byte);
	printf("4-byte UTF-8 characters: %lu\n", amount_4_byte);
}
