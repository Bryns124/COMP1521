# this code reads 1 integer and prints it
# add code so that prints 1 iff
# the least significant (bottom) byte of the number read
# is equal to the 2nd least significant byte
# and it prints 0 otherwise

main:
    li   $v0, 5
    syscall

    and  $t0, $v0, 0xff
    srl  $t1, $v0, 8
    and  $t2, $t1, 0xff

if_1:
    bne  $t0, $t2, print_0
    j    print_1

print_0:
    li   $a0, 0
    li   $v0, 1
    syscall
    
    li   $a0, '\n'
    li   $v0, 11
    syscall

    j    end

print_1:
    li   $a0, 1
    li   $v0, 1
    syscall

    li   $a0, '\n'
    li   $v0, 11
    syscall
end:
    jr   $ra
