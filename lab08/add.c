#include <stdio.h>
#include <stdint.h>
#include <assert.h>

#include "add.h"

// return the MIPS opcode for add $d, $s, $t
uint32_t make_add(uint32_t d, uint32_t s, uint32_t t) {

    uint32_t result = 0b00000000000000000000000000100000;
    
    result = result | (s << 21);
    result = result | (t << 16);
    result = result | (d << 11);

    return result;

}
