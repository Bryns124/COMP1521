# Read a number and print positive multiples of 7 or 11 < n

main:                  # int main(void) {

    la   $a0, prompt   # printf("Enter a number: ");
    li   $v0, 4
    syscall

    li   $v0, 5         # scanf("%d", number);
    syscall

    move $s0, $v0

    li $s1, 1           # int i = 1;

loop: 
    beq $s1, $s0, loop_end

    bge $s1, $s0, loop_end
    
    rem $t0, $s1, 7

    beq $t0, $zero, print

    rem $t1, $s1, 11

    beq $t1, $zero, print

    add $s1, $s1, 1

    j loop

print:
    move $a0, $s1
    li $v0, 1
    syscall

    li $a0, '\n'
    li $v0, 11
    syscall
    
    add $s1, $s1, 1

    j loop

loop_end:
    jr   $ra           # return

    .data
prompt:
    .asciiz "Enter a number: "