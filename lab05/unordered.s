# Read 10 numbers into an array
# print 0 if they are in non-decreasing order
# print 1 otherwise

# i in register $t0

main:

    li   $t0, 0         # i = 0
loop0:
    bge  $t0, 10, end0  # while (i < 10) {

    li   $v0, 5         #   scanf("%d", &numbers[i]);
    syscall             #

    mul  $t1, $t0, 4    #   calculate &numbers[i]
    la   $t2, numbers   #
    add  $t3, $t1, $t2  #
    sw   $v0, ($t3)     #   store entered number in array

    addi $t0, $t0, 1    #   i++;
    j    loop0          # }
end0:

    li   $t4, 0         # swapped = 0;
    li   $t0, 1         # i = 1;

loop1:
    bge $t0, 10, print   # while (i < 10) {
    
    mul  $t1, $t0, 4    #   calculate &numbers[i]
    la   $t2, numbers   #
    add  $t3, $t1, $t2  #
    lw   $t5, ($t3)

    sub  $t6, $t0, 1

    mul  $t7, $t6, 4    #   calculate &numbers[i]
    add  $t8, $t7, $t2  #
    lw   $t9, ($t8)

    bge  $t5, $t9, addonloop1
    li   $t4, 1

addonloop1:

    addi $t0, $t0, 1
    j    loop1

print:

    move $a0, $t4        # printf("%d", 42)
    li   $v0, 1         #
    syscall

    li   $a0, '\n'      # printf("%c", '\n');
    li   $v0, 11
    syscall

end1:

    jr   $ra

.data

numbers:
    .word 0 0 0 0 0 0 0 0 0 0  # int numbers[10] = {0};

