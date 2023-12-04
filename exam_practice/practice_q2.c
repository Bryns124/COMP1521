#include <assert.h>
#include <stdint.h>
#include <stdlib.h>

// given a uint32_t value,
// return 1 iff the least significant (bottom) byte
// is equal to the 2nd least significant byte; and
// return 0 otherwise
int practice_q2(uint32_t value) {

    uint32_t lsb = value & 0xFF;
    uint32_t slsb = (value >> 8) & 0xFF;

    if (lsb == slsb) {
        return 1;
    }
    else {
        return 0;
    }
}
