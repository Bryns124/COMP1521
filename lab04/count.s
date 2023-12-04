# read a number n and print the integers 1..n one per line

main:
    
    la   $a0, prompt    # printf("Enter number: ");
    li   $v0, 4
    syscall

    li   $v0, 5         # scanf("%d", number);
    syscall

    move $t0, $v0

    li $t1, 1           # i = 1;

loop:
    
    bgt $t1, $t0, loop_end      # if (i < number) goto loop_end

    move $a0, $t1
    li $v0, 1
    syscall                     # printf("%d", number);

    li $a0, '\n'
    li $v0, 11
    syscall                     # printf("%c", '\n');

    add $t1, $t1, 1

    j loop
    
loop_end: 
    li   $v0, 0       # return 0
    jr   $ra

    .data

prompt:
    .asciiz "Enter a number: "