

main:

    la   $a0, msg1
    li   $v0, 4
    syscall            # printf(Enter n: ")

    li    $v0, 5
    syscall            # scanf("%d", &n)
    move  $s0, $v0     # saving n

    li    $t0, 0        # saving $t0 = 0 for later use.
    li    $t1, 1        # saving $t1 = 1 for later use.
    li    $t2, 10       # saving $t2 = 10 for later use.

    li    $t3, 1        # m = 1;
    sw    $t1, fact($t0)    # fact[0] = 1;
    li    $t4, 2        # i = 2;

loop1_start:
    bgt   $t4, $s0, loop1_end

    li    $t5, 0        # temp = 0
    li    $t6, 0        # k = 0
loop2_start:
    bge   $t6, $t3, loop2_end

    mul   $t6, $t6, 4       # calculating address
    lw    $t7, fact($t6)    # loading value inside address into register/
    mul   $t9, $t7, $t4     # fact[k]*i
    add   $t5, $t5, $t9     # temp = temp + fact[k]*i
    rem   $t7, $t5, $t2     # fact[k] = temp%10
    div   $t5, $t5, $t2     # temp = temp/10
    addi  $t6, $t6, 1       # k++
    j     loop2_start
loop2_end:
loop3_start:
    ble   $t5, 0, loop3_end

    mul   $t3, $t3, 4       # calculating address
    lw    $t8, fact($t3)    # loading value inside address into register/
    rem   $t8, $t5, $t2     # fact[m] = temp%10
    addi  $t3, $t3, 1       # m++
    div   $t5, $t5, $t2     # temp = temp/10;
    j     loop3_start
loop3_end:
    addi  $t4, $t4, 1
    j     loop1_start
loop1_end:
    move  $a0, $s0
    li    $v0, 1
    syscall            # printf ("%d", n)

    la    $a0, msg2
    li    $v0, 4
    syscall            # printf("! = ")

    sub   $t6, $t3, 1     # k = m - 1

print_factorial_loop:
    blt   $t6, 0, print_factorial_loop_end

    mul   $t6, $t6, 4       # calculating address
    lw    $t7, fact($t6)    # loading value inside address into register/
    move  $a0, $t7
    li    $v0, 1
    syscall            # printf ("%d", fact[k])

    addi   $t6, $t6, -1
print_factorial_loop_end:
    li   $a0, '\n'     # printf("%c", '\n');
    li   $v0, 11
    syscall
end:
    jr   $ra
    
    .data
msg1:   .asciiz "Enter n: "
msg2:   .asciiz "! = "
fact:
    .align 2
    .space 800