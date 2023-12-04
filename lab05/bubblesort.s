# read 10 numbers into an array
# bubblesort them
# then print the 10 numbers

# i in register $t0
# registers $t1, $t2 & $t3 used to hold temporary results

main:

    li   $t0, 0         # i = 0
loop_first:
    bge  $t0, 10, loop_first_end  # while (i < 10) {

    li   $v0, 5         #   scanf("%d", &numbers[i]);
    syscall             #

    mul  $t1, $t0, 4    #   calculate &numbers[i]
    la   $t2, numbers   #
    add  $t3, $t1, $t2  #
    sw   $v0, ($t3)     #   store entered number in array

    addi $t0, $t0, 1    #   i++;
    j    loop_first         # }
loop_first_end:

    li   $t4, 1
loop_second:
    beqz $t4, loop_second_end

    li   $t4, 0
    li   $t0, 1

loop_inside_loop_second:
    bge  $t0, 10, loop_inside_loop_second_end
    
    mul  $t1, $t0, 4    #   calculate &numbers[i]
    la   $t2, numbers   #
    add  $t3, $t1, $t2  #
    lw   $t5, ($t3)     # x 

    sub  $t6, $t0, 1

    mul  $t7, $t6, 4    #   calculate &numbers[i]
    add  $t8, $t7, $t2  #
    lw   $t9, ($t8)     # y

if_statement:
    bge  $t5, $t9, addonloop1
    sw   $t9, ($t3)
    sw   $t5, ($t8)
    li   $t4, 1

addonloop1:
    addi $t0, $t0, 1
    j    loop_inside_loop_second

loop_inside_loop_second_end:
    j    loop_second

loop_second_end:
    li   $t0, 0         # i = 0

loop_last:
    bge  $t0, 10, end1  # while (i < 10) {

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
    j    loop_last          # }
end1:

    jr   $ra            # return

.data

numbers:
    .word 0 0 0 0 0 0 0 0 0 0  # int numbers[10] = {0};

