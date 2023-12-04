# read a line and print whether it is a palindrom

main:
    la   $a0, str0       # printf("Enter a line of input: ");
    li   $v0, 4
    syscall

    la   $a0, line
    la   $a1, 256
    li   $v0, 8          # fgets(buffer, 256, stdin)
    syscall              #

    li   $t0, 0                 # i = 0
loop0_start:
    lb   $t1, line($t0)         # $t1 = line[i]
    beq  $t1, 0, loop0_end

    addi $t0, $t0, 1
    j    loop0_start
loop0_end:
    li   $t2, 0
    sub  $t3, $t0, 2
loop1_start:
    bge  $t2, $t3, loop1_end
if_start:
    lb   $t4, line($t2)
    lb   $t5, line($t3)
    beq  $t4, $t5, if_end
    la   $a0, not_palindrome
    li   $v0, 4
    syscall
    li   $v0, 0          # return 0
    jr   $ra
if_end:
    addi $t2, $t2, 1
    addi $t3, $t3, -1
    j    loop1_start
loop1_end:

    la   $a0, palindrome
    li   $v0, 4
    syscall

    li   $v0, 0          # return 0
    jr   $ra


.data
str0:
    .asciiz "Enter a line of input: "
palindrome:
    .asciiz "palindrome\n"
not_palindrome:
    .asciiz "not palindrome\n"


# line of input stored here
line:
    .space 256

