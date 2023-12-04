#include <stdio.h>
#include <ctype.h>

int make_lower(int character);

int main(void) {

    int read_character = getchar();

    while (read_character != EOF) {
        
        int upper_case = make_lower(read_character);
        putchar(upper_case);
 
        read_character = getchar();
    }

    return 0;
}

int make_lower(int character) {
	int alphabet_position;
	if (character >= 'A' && character <= 'Z') {
		alphabet_position = character - 'A';
		return 'a' + alphabet_position;
	}
	return character;
}