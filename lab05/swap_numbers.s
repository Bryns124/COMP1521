# read 10 numbers into an array
# swap any pairs of of number which are out of order
# then print the 10 numbers

# i in register $t0,
# registers $t1 - $t3 used to hold temporary results

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

    li   $t0, 1         # i = 1
loop1:
    bge  $t0, 10, end1  # while (i < 10) {

    mul  $t1, $t0, 4    #   calculate &numbers[i]
    la   $t2, numbers   #   
    add  $t3, $t1, $t2  #
    lw   $t4, ($t3)

    sub  $t5, $t0, 1

    mul  $t6, $t5, 4
    add  $t7, $t6, $t2
    lw   $t8, ($t7)

    bge  $t4, $t8, addonloop1
    sw   $t8, ($t3)
    sw   $t4, ($t7)

addonloop1:

    addi $t0, $t0, 1    #   i++
    j    loop1          # }

end1:

    li   $t0, 0         # i = 0

loop2:

    bge  $t0, 10, end2
    
    mul  $t1, $t0, 4    #   calculate &numbers[i]
    la   $t2, numbers   #   
    add  $t3, $t1, $t2  #
    lw   $a0, ($t3)     #   load numbers[i] into $a0
    li   $v0, 1         #   printf("%d", numbers[i])
    syscall

    li   $a0, '\n'      #   printf("%c", '\n');
    li   $v0, 11
    syscall

    addi $t0, $t0, 1    #   i++
    j    loop2          # }

end2:

    jr   $ra

.data

numbers:
    .word 0 0 0 0 0 0 0 0 0 0  # int numbers[10] = {0};

