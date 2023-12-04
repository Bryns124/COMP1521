// Swap bytes of a short

#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

// given uint16_t value return the value with its bytes swapped
uint16_t short_swap(uint16_t value) {
    
    int firstTwo = value >> 8;
    int secondTwo = value << 8;

    int result = firstTwo | secondTwo;

    return result;
}
