# COMP1521 21T2 ... final exam, question 2

    .data
even_parity_str:    .asciiz "the parity is even\n"
odd_parity_str:     .asciiz "the parity is odd\n"

    .text
main:
    li  $v0, 5
    syscall
    move    $t0, $v0
    # input is in $t0
    li  $t1, 0  # bit_idx = 0
    li  $t2, 0  # n_bits_set = 0

loop:
    beq $t1, 32, loop_end
    srav$t3, $t0, $t1   # n >> bit_idx
    li  $t5, 1
    and $t4, $t3, $t5
    add $t2, $t2, $t4
    addi$t1, $t1, 1
    j   loop
loop_end:
    li  $t5, 2
if:
    rem $t6, $t2, $t5
    beq $t6, 0, print_else

print_if:
    li  $v0, 4
    la  $a0, odd_parity_str
    syscall
    j   end
print_else:
    li  $v0, 4
    la  $a0, even_parity_str
    syscall
    j   end
end:
    li  $v0, 0
    jr  $ra

