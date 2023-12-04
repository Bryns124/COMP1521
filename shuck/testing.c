#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>

int main(int argc, char *argv[]) {

   FILE *output_stream = fopen("tc.txt","a");

   char buffer_out[100] = {0};

   int i = 0;
   while (argv[i] != NULL) {
      strcat(buffer_out, argv[i]);
      strcat(buffer_out, " ");
      i++;
   }
   fwrite(buffer_out, sizeof(char), strlen(buffer_out), output_stream);
   // fflush(output_stream);
   // fprintf(output_stream, "%s\n", buffer_out);

   fclose(output_stream);

   return 0;

}