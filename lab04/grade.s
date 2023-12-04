# read a mark and print the corresponding UNSW grade

main:
    la   $a0, prompt    # printf("Enter a mark: ");
    li   $v0, 4
    syscall

    li   $v0, 5         # scanf("%d", mark);
    syscall

    move $t0, $v0

    ble $t0, 49, fl     # if (mark <= 49) {};

    ble $t0, 64, ps     # if (mark <= 64) {};

    ble $t0, 74, cr     # if (mark <= 74) {};

    ble $t0, 84, dn     # if (mark <= 84) {};

    ble $t0, 100, hd    # if (mark <= 100) {};

fl:
    la   $a0, fl_str        # printf("FL\n");
    li   $v0, 4
    syscall
    j end
ps:
    la   $a0, ps_str        # printf("PS\n");
    li   $v0, 4
    syscall
    j end

cr:
    la   $a0, cr_str        # printf("CR\n");
    li   $v0, 4
    syscall
    j end

dn:
    la   $a0, dn_str        # printf("DN\n");
    li   $v0, 4
    syscall
    j end

hd:
    la   $a0, hd_str        # printf("HD\n");
    li   $v0, 4
    syscall
    j end

end: 
    jr   $ra            # return

    .data
prompt:
    .asciiz "Enter a mark: "
fl_str:
    .asciiz "FL\n"
ps_str:
    .asciiz "PS\n"
cr_str:
    .asciiz "CR\n"
dn_str:
    .asciiz "DN\n"
hd_str:
    .asciiz "HD\n"
