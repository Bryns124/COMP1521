# this code reads 1 integer and prints it
# change it to read integers until their sum is >= 42
# and then print theintgers read in reverse order

main:

    li   $t0, 0         # i = 0
    li   $t1, 0         # sum = 0

loop1:
    bge  $t1, 42, loop1_end
    li   $v0, 5        #   scanf("%d", &x);
    syscall            #
    move $t2, $v0       # $t2 = x

    mul  $t3, $t0, 4
    sw   $t2, numbers($t3)
    addi $t0, $t0, 1
    add  $t1, $t1, $t2
    j    loop1
loop1_end:

loop2:
    ble  $t0, 0, loop2_end
    addi $t0, $t0, -1

    mul  $t3, $t0, 4
    lw   $a0, numbers($t3)  #   printf("%d\n", x);
    li   $v0, 1
    syscall

    li   $a0, '\n'     #   printf("%c", '\n');
    li   $v0, 11
    syscall

    j    loop2

loop2_end:
    jr   $ra

.data
numbers:
    .space 4000