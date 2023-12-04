#include <stdio.h>
#include <stdlib.h>

int collatz(int input_num);

int main(int argc, char **argv) {

	int i = 1;
	int input_num = strtol(argv[i], NULL, 10);
	printf("%d\n", input_num);
	collatz(input_num);
	return EXIT_SUCCESS;
}

int collatz(int input_num) {
	if (input_num == 1) {
		return 0;
	}

	else if (input_num % 2 == 0) {
		input_num = input_num / 2;
		printf("%d\n", input_num);
	}

	else if (input_num % 2 == 1) {
		input_num = (input_num * 3) + 1;
		printf("%d\n", input_num);
	}
	return collatz(input_num);
}
