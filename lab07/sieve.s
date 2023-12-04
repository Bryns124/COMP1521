# Sieve of Eratosthenes
# https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes
main:

    li $t0, 0
loop1_start:
    bge $t0, 1000, loop1_end

    li  $t1, 1
    sb  $t1, prime($t0)
    addi $t0, $t0, 1

    j   loop1_start
loop1_end:
    
    li $t0, 2
loop2_start:
    bge $t0, 1000, loop2_end
if_start:
    lb  $t2, prime($t0)
    bne $t2, 1, if_end

    move $a0, $t0
    li $v0, 1
    syscall

    li   $a0, '\n'      # printf("%c", '\n');
    li   $v0, 11
    syscall

    li $t3, 2
    mul $t4, $t3, $t0
loop3_start:
    bge $t4, 1000, loop3_end

    li $t3, 0
    sb $t3, prime($t4)
    add $t4, $t4, $t0

    j   loop3_start
loop3_end:

if_end:
    addi $t0, $t0, 1
    j   loop2_start

loop2_end:
    j end

end:
    li $v0, 0           # return 0
    jr $ra


.data
prime:
    .space 1000