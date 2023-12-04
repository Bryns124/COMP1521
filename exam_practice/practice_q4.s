# this code reads 1 integer and prints it
# change it to read integers until their sum is >= 42
# and then print their sum

main:

    li   $t0, 0         # sum = 0

loop1:

    bge  $t0, 42, loop1_end

    li   $v0, 5        #   scanf("%d", &x);
    syscall            #
    move $t1, $v0       # $t1 = x
    add  $t0, $t0, $t1
    j    loop1

loop1_end:

    move $a0, $t0      #   printf("%d\n", sum);
    li   $v0, 1
    syscall

    li   $a0, '\n'     #   printf("%c", '\n');
    li   $v0, 11
    syscall
end:
    li   $v0, 0        # return 0
    jr   $ra
