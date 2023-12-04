#include <stdio.h>

int main(int argc, char **argv) {
	
	int i = 1;
	printf("Program name: %s\n", argv[i-1]);
	if (argc != 1) {
		printf("There are %d arguments:\n", argc-1);	
		while (i < argc) {
			printf("	Argument %d is \"%s\"\n", i , argv[i]);
			i++;
		}
	}
	else {
		printf("There are no other arguments\n");
	}
	return 0;
}
