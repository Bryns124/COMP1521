// COMP1521 21T2 ... final exam, question 0

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int
count_leading_zeroes (uint32_t x)
{
	int msb = (uint)1 << 31;
	int count_zeroes = 0;
	while (!(x & msb)) {
        x = x << 1;
        count_zeroes++;
    }
	return count_zeroes;
}

