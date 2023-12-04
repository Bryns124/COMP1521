////////////////////////////////////////////////////////////////////////
// COMP1521 21t2 -- Assignment 2 -- shuck, A Simple Shell
// <https://www.cse.unsw.edu.au/~cs1521/21T2/assignments/ass2/index.html>
//
// Written by Bryan Le (z5361001) on 03/08/2021.
//
// 2021-07-12    v1.0    Team COMP1521 <cs1521@cse.unsw.edu.au>
// 2021-07-21    v1.1    Team COMP1521 <cs1521@cse.unsw.edu.au>
//     * Adjust qualifiers and attributes in provided code,
//       to make `dcc -Werror' happy.
//

#include <sys/types.h>

#include <sys/stat.h>
#include <sys/wait.h>

#include <assert.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <limits.h>
// [[ TODO: put any extra `#include's here ]]
#include <spawn.h>

// [[ TODO: put any `#define's here ]]
#define RUN 0
#define NOT_COMMAND 0
//
// Interactive prompt:
//     The default prompt displayed in `interactive' mode --- when both
//     standard input and standard output are connected to a TTY device.
//
static const char *const INTERACTIVE_PROMPT = "shuck& ";

//
// Default path:
//     If no `$PATH' variable is set in Shuck's environment, we fall
//     back to these directories as the `$PATH'.
//
static const char *const DEFAULT_PATH = "/bin:/usr/bin";

//
// Default history shown:
//     The number of history items shown by default; overridden by the
//     first argument to the `history' builtin command.
//     Remove the `unused' marker once you have implemented history.
//
static const int DEFAULT_HISTORY_SHOWN __attribute__((unused)) = 10;

//
// Input line length:
//     The length of the longest line of input we can read.
//
static const size_t MAX_LINE_CHARS = 1024;

//
// Special characters:
//     Characters that `tokenize' will return as words by themselves.
//
static const char *const SPECIAL_CHARS = "!><|";

//
// Word separators:
//     Characters that `tokenize' will use to delimit words.
//
static const char *const WORD_SEPARATORS = " \t\r\n";

// [[ TODO: put any extra constants here ]]


// [[ TODO: put any type definitions (i.e., `typedef', `struct', etc.) here ]]

static void execute_command(char **words, char **path, char **environment);
static void do_exit(char **words);
static int is_executable(char *pathname);
static char **tokenize(char *s, char *separators, char *special_chars);
static void free_tokens(char **tokens);

// [[ TODO: put any extra function prototypes here ]]
void my_cd(char *program, char **words, char *home_path);
// void my_history(FILE *input_stream);
int my_bin_commands(char *program, char **words, char **environ);
void print_command_line_into_history(FILE* output_stream, char buffer_out[], char **words);

int main (void)
{
    // Ensure `stdout' is line-buffered for autotesting.
    setlinebuf(stdout);

    // Environment variables are pointed to by `environ', an array of
    // strings terminated by a NULL value -- something like:
    //     { "VAR1=value", "VAR2=value", NULL }
    extern char **environ;

    // Grab the `PATH' environment variable for our path.
    // If it isn't set, use the default path defined above.
    char *pathp;
    if ((pathp = getenv("PATH")) == NULL) {
        pathp = (char *) DEFAULT_PATH;
    }
    char **path = tokenize(pathp, ":", "");

    // Should this shell be interactive?
    bool interactive = isatty(STDIN_FILENO) && isatty(STDOUT_FILENO);

    // Main loop: print prompt, read line, execute command
    while (1) {
        // If `stdout' is a terminal (i.e., we're an interactive shell),
        // print a prompt before reading a line of input.
        if (interactive) {
            fputs(INTERACTIVE_PROMPT, stdout);
            fflush(stdout);
        }

        char line[MAX_LINE_CHARS];
        if (fgets(line, MAX_LINE_CHARS, stdin) == NULL)
            break;

        // Tokenise and execute the input line.
        char **command_words =
            tokenize(line, (char *) WORD_SEPARATORS, (char *) SPECIAL_CHARS);
        execute_command(command_words, path, environ);
        free_tokens(command_words);
    }

    free_tokens(path);
    return 0;
}


//
// Execute a command, and wait until it finishes.
//
//  * `words': a NULL-terminated array of words from the input command line
//  * `path': a NULL-terminated array of directories to search in;
//  * `environment': a NULL-terminated array of environment variables.
//
static void execute_command(char **words, char **path, char **environment)
{
    assert(words != NULL);
    assert(path != NULL);
    assert(environment != NULL);

    // FILE* output_stream = fopen(".shuck_history", "a");
    // FILE *input_stream = fopen(".shuck_history", "r");

    extern char **environ;
    char *program = words[0];
    // char buffer_out[50];
    // int character = 0;

    char *home_path = getenv("HOME");
    char *pwd_path = getenv("PWD");

    if (program == NULL) {
        // Nothing to do
        return;
    }


    if (strcmp(program, "exit") == RUN) {
        do_exit(words);
        // `do_exit' will only return if there was an error.
        return;
    }

    if (strcmp(program, "cd") == RUN) {
        my_cd(program, words, home_path);
        // 'my_cd' only returns when:
        // - Nothing is entered afer 'cd'
        // - A directory is entered after 'cd'
        // Otherwise, it prints an error message.
        return;
    }

    if (strcmp(program, "pwd") == RUN) {
        printf("current directory is '%s'\n", pwd_path);
        // Prints currently working directory.
        return;
    }

    if (my_bin_commands(program, words, environ)) {
        // 'my_bin_commands' returns 1 in order to run. 
        // Runs whatever command is entered in command line.
        // Returns after it is run.
        return;
    }

    // if (strcmp(program, "history") == RUN) {
    //     my_history(input_stream);
    //     // 'my_history' prints the history of previous commands entered.
    //     return;
    // }

   FILE *output_stream = fopen(".shuck_history","a");

   char buffer_out[100] = {0};

   int i = 0;
    // Error checking if output_stream points at a file.
    if (output_stream == NULL) {
        perror(".shuck_history");
    }
    while (words[i] != NULL) {
      strcat(buffer_out, " ");
      strcat(buffer_out, words[i]);
      i++;
    }
    fwrite(buffer_out, sizeof(char), strlen(buffer_out), output_stream);
    // fflush(output_stream);
    // fprintf(output_stream, "%s\n", buffer_out);

    fclose(output_stream);

    // fclose(input_stream);

}

// Changes directory to words[1].
// If nothing is entered after 'cd,' then program returns to
// home directory.
// If the directory entered does not exist, an error message
// is printed and program returns.
// If there is more than 3 arguments entered, an error message
// is printed and program returns.
void my_cd(char *program, char **words, char *home_path)
{
    if (words[1] == NULL) {
        chdir(home_path);
        setenv("PWD", home_path, 1);
        return;
    }
    else if (words[2] == NULL) {
        if (chdir(words[1]) != 0) {
            fprintf(stderr, "cd: %s: No such file or directory\n", words[1]);
        }
        setenv("PWD", words[1], 1);
        return;
    }
    else if (words[1] != NULL && words[2] != NULL) {
        fprintf(stderr, "cd: too many arguments\n");
    }
} 

// Prints all of the content within the '.shuck_history' file,
// which contains all previous commands run.
// Reads the file byte by byte and prints byte by byte as well.
// (Previously implemented correctly but no longer works).
// void my_history(FILE *input_stream)
// {
//     int byte;
//     while ((byte = fgetc(input_stream)) != EOF) {
//         fputc(byte, stdout);
//     }
// }

// Contains and executes all files that are commands in /bin directory.
int my_bin_commands(char *program, char **words, char **environ) 
{
    pid_t pid = 0;
    int exit_status = 0;
	int i = 0;
    int j = 0;
    // Gets the environment variable $PATH and splits the values in 
    // it into an array of strings, separated by ":"
    char *path_env = getenv("PATH");
    char **all_paths = tokenize(path_env, ":", "");

	int pathname_length = strlen(all_paths[i]) + 100;	
	char command_pathname[pathname_length];
    // Checks through the string 'program' for the last occurence of '/'
    // Goes through condition where '/' does not appear. 
    if (strrchr(program, '/') == NULL) {
        while (all_paths[i] != NULL) {
            // Appends to all paths in $PATH and prints them. 
            snprintf(command_pathname, sizeof(command_pathname), "%s/%s", all_paths[i], words[0]); 
            if (is_executable(command_pathname)) {
                // Spawns process to run command and waits for spawned process to finish. 
                posix_spawn(&pid, command_pathname, NULL, NULL, words, environ);
                waitpid(pid, &exit_status, 0);
                printf("%s exit status = %d\n", command_pathname, WEXITSTATUS(exit_status));
                j++;
                break;
            }
            i++;
        }
    } else {
    // Goes through condition where '/' does appear. 
        strcpy(command_pathname, words[0]);
        if (is_executable(command_pathname)) {
            // Spawns process to run command and waits for spawned process to finish. 
            posix_spawn(&pid, command_pathname, NULL, NULL, words, environ);
            waitpid(pid, &exit_status, 0);
            printf("%s exit status = %d\n", command_pathname, WEXITSTATUS(exit_status));
            j++;
        }
    }
    // Error checking if the command entered exists.
    // If the process is spawned and the command is run, j would not equal 0.
    if (j == NOT_COMMAND) {
        fprintf(stderr, "%s: command not found\n", words[0]);
    }
    return 1;
}

// Appends the words[] from the command line into the character array
// 'command_into_file'. Then, hold the command_into_file string inside
// 'buffer_out' to be transferred and written into the file. Everytime
// after a line is written, the string is replaced with '\0,' empyting
// it for the next command.
// (Previously implemented correctly but no longer works).
void print_command_line_into_history(FILE* output_stream, char buffer_out[], char **words)
{
    char command_into_file[50];
    // Error checking if output_stream points at a file.
    if (output_stream == NULL) {
        perror(".shuck_history");
    }
    snprintf(buffer_out, 256, "%s\n", command_into_file);
    size_t bytes_wrote = fwrite(buffer_out, sizeof(char), strlen(buffer_out), output_stream);
    // Error checking for number of bytes written.
    if (bytes_wrote != strlen(buffer_out)) {
        perror("bytes_wrote");
    }
}

//
// Implement the `exit' shell built-in, which exits the shell.
//
// Synopsis: exit [exit-status]
// Examples:
//     % exit
//     % exit 1
//
static void do_exit(char **words)
{
    assert(words != NULL);
    assert(strcmp(words[0], "exit") == 0);

    int exit_status = 0;

    if (words[1] != NULL && words[2] != NULL) {
        // { "exit", "word", "word", ... }
        fprintf(stderr, "exit: too many arguments\n");

    } else if (words[1] != NULL) {
        // { "exit", something, NULL }
        char *endptr;
        exit_status = (int) strtol(words[1], &endptr, 10);
        if (*endptr != '\0') {
            fprintf(stderr, "exit: %s: numeric argument required\n", words[1]);
        }
    }

    exit(exit_status);
}


//
// Check whether this process can execute a file.  This function will be
// useful while searching through the list of directories in the path to
// find an executable file.
//
static int is_executable(char *pathname)
{
    struct stat s;
    return
        // does the file exist?
        stat(pathname, &s) == 0 &&
        // is the file a regular file?
        S_ISREG(s.st_mode) &&
        // can we execute it?
        faccessat(AT_FDCWD, pathname, X_OK, AT_EACCESS) == 0;
}


//
// Split a string 's' into pieces by any one of a set of separators.
//
// Returns an array of strings, with the last element being `NULL'.
// The array itself, and the strings, are allocated with `malloc(3)';
// the provided `free_token' function can deallocate this.
//
static char **tokenize(char *s, char *separators, char *special_chars)
{
    size_t n_tokens = 0;

    // Allocate space for tokens.  We don't know how many tokens there
    // are yet --- pessimistically assume that every single character
    // will turn into a token.  (We fix this later.)
    char **tokens = calloc((strlen(s) + 1), sizeof *tokens);
    assert(tokens != NULL);

    while (*s != '\0') {
        // We are pointing at zero or more of any of the separators.
        // Skip all leading instances of the separators.
        s += strspn(s, separators);

        // Trailing separators after the last token mean that, at this
        // point, we are looking at the end of the string, so:
        if (*s == '\0') {
            break;
        }

        // Now, `s' points at one or more characters we want to keep.
        // The number of non-separator characters is the token length.
        size_t length = strcspn(s, separators);
        size_t length_without_specials = strcspn(s, special_chars);
        if (length_without_specials == 0) {
            length_without_specials = 1;
        }
        if (length_without_specials < length) {
            length = length_without_specials;
        }

        // Allocate a copy of the token.
        char *token = strndup(s, length);
        assert(token != NULL);
        s += length;

        // Add this token.
        tokens[n_tokens] = token;
        n_tokens++;
    }

    // Add the final `NULL'.
    tokens[n_tokens] = NULL;

    // Finally, shrink our array back down to the correct size.
    tokens = realloc(tokens, (n_tokens + 1) * sizeof *tokens);
    assert(tokens != NULL);

    return tokens;
}


//
// Free an array of strings as returned by `tokenize'.
//
static void free_tokens(char **tokens)
{
    for (int i = 0; tokens[i] != NULL; i++) {
        free(tokens[i]);
    }
    free(tokens);
}
