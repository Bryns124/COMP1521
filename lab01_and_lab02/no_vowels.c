#include <stdio.h>
#include <string.h>

char is_vowel(char character);

int main(void) {

	char read_character;

	while (scanf("%c", &read_character) != EOF) {
		if (is_vowel(read_character) == 1) {
		} 
		else if (is_vowel(read_character) == 0) {
			printf("%c", read_character);
		}
	}

	return 0;
}

char is_vowel(char character) {

	if (character == 'a' || character == 'e' || character == 'i' || character == 'o' || character == 'u' ||
		character == 'A' || character == 'E' || character == 'I' || character == 'O' || character == 'U' ) {
		return 1;
	}
	else {
		return 0;
	}
}