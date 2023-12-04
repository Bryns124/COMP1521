#include <stdio.h>

int main(void) {
    
    int num[3];

int i =0;

while (i < 3) {
    scanf("%d", &num[i]);
    i++;
}

if (num[0] == 1) {
    int sq = num[1]*num[1];
    printf("%d\n", sq);
}
}