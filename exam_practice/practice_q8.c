#include <stdio.h>
#include <stdlib.h>

void process_file(char *pathname)

int main(int argc, char *argv[]) {

    int arg = 1;
    while (arg < argc) {
        process_file(argv[arg]);
        arg++;
    }

    return 0;
}

void process_file(char *pathname) {



}