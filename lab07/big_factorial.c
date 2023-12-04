#include <stdio.h>

#define MAX 200

int main() {
    int n;
    int fact[200];
    int i;
    int temp;
    int m;
    int k; 

    printf("Enter n: ");
    scanf("%d",&n);
    m = 1; 
    fact[0] = 1;
    i = 2;
    while (i <= n) {
        temp = 0; 
        k = 0;
        while (k < m) {
            temp += fact[k]*i; 
            fact[k] = temp%10; 
            temp = temp/10; 
            k++;
        }
        while(temp > 0) {
            fact[m] = temp%10; 
            m++; 
            temp = temp/10; 
        }
    i++;
    }
    printf("%d! = ", n);
    k = m - 1;
    while (k >= 0) {
        printf("%d",fact[k]); 
    k--;
    }
    printf("\n"); 
    return 0; 
} 
