#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
#include <stdlib.h>

long file_for_stat(char *pathname);

int main(int argc, char *argv[]) {
    long totalBytes = 0;
    int arg = 1;
    while(arg < argc) {
        totalBytes = totalBytes + file_for_stat(argv[arg]);  
        arg++;
    }
    printf("Total: %ld bytes\n", totalBytes);

    return 0;
}

long file_for_stat(char *pathname) {
    struct stat s;
    if (stat(pathname, &s) != 0) {
        perror(pathname);
        exit(1);
    }
    
    printf("%s: %ld bytes\n", pathname, s.st_size);
    
    return s.st_size;
}
