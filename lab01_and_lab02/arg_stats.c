#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
	
	int i = 0;
	int min = strtol(argv[i+1], NULL, 10);
	int max = strtol(argv[i+1], NULL, 10);
	int sum = 0;
	int prod = 1;
	int mean = sum / argc;
	
	while (i < argc - 1) {
	 	if (min < strtol(argv[i+1], NULL, 10)) {
	 	} else {
	 		min = strtol(argv[i+1], NULL, 10);
	 	}
	 	if (max > strtol(argv[i+1], NULL, 10)) {
	 	} else {
	 		max = strtol(argv[i+1], NULL, 10);
	 	}
		sum += strtol(argv[i+1], NULL, 10);
	    prod *= strtol(argv[i+1], NULL, 10);
        mean = sum / (argc - 1);
	    i++;
	}
	
	printf("MIN:  %d\n", min);
	printf("MAX:  %d\n", max);
	printf("SUM:  %d\n", sum);
	printf("PROD: %d\n", prod);
    printf("MEAN: %d\n", mean);
        
	return 0;
}
