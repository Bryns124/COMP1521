# Read a number n and print the first n tetrahedral numbers
# https://en.wikipedia.org/wiki/Tetrahedral_number

main:                  # int main(void) {

    la   $a0, prompt   # printf("Enter how many: ");
    li   $v0, 4
    syscall

    li   $v0, 5         # scanf("%d", how_many);
    syscall

    move $s0, $v0

    li   $s1, 1           # n = 1

loop1_start:
    bgt  $s1, $s0, loop1_end

    li   $t0, 0       # total = 0;
    li   $t1, 1       # j = 1

loop2_start:
    bgt  $t1, $s1, loop2_end

    li   $t2, 1       # i = 1
loop3_start:
    bgt  $t2, $t1, loop3_end
    
    add  $t0, $t0, $t2
    add  $t2, $t2, 1

    j    loop3_start

loop3_end:
    add  $t1, $t1, 1

    j    loop2_start

loop2_end:
    move $a0, $t0
    li   $v0, 1
    syscall

    li   $a0, '\n'
    li   $v0, 11
    syscall

    add  $s1, $s1, 1

    j    loop1_start

loop1_end:
    jr   $ra           # return

    .data
prompt:
    .asciiz "Enter how many: "
