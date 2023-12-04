#include <stdio.h>
#include <string.h>

#define MAX_LINE_LENGTH 128

int main(void) {
	
	char line[MAX_LINE_LENGTH] = {};

	while (fgets(line, MAX_LINE_LENGTH, stdin) != NULL) {
		if (strlen(line) % 2 == 0) {
			fputs(line, stdout);
		} else {
		}
	}
	return 0;
}
