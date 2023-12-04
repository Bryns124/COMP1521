main:
    li   $v0, 5         #   scanf("%d", &x);
    syscall             #
    move $t0, $v0

    li   $t1, 0         # i = 0
loop0: 
    bge  $t1, $t0, end  # while (i >= x)
    li   $t2, 0         # j = 0

loop1:
    bge  $t2, $t0, loop1_end    # while (j >= x)

    li   $a0, '*'        #   printf("*");
    li   $v0, 11
    syscall

    addi $t2, $t2, 1
    j    loop1

loop1_end:
    addi $t1, $t1, 1
    li   $a0, '\n'      #   printf("%c", '\n');
    li   $v0, 11
    syscall
    j    loop0

end:

    li   $v0, 0         # return 0
    jr   $ra
