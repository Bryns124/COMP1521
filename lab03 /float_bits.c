// Extract the 3 parts of a float using bit operations only

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#include "floats.h"

// separate out the 3 components of a float
float_components_t float_bits(uint32_t f) {
    uint32_t sign = f >> 31;
    int maskExponent = 0b01111111100000000000000000000000;
    uint32_t exponent = (f & maskExponent) >> 23;
    int maskFraction = 0b00000000011111111111111111111111;
    uint32_t fraction = (f & maskFraction);

    float_components_t float_parts;
        float_parts.sign = sign;
        float_parts.exponent = exponent;
        float_parts.fraction = fraction;
        return float_parts;
    }

// given the 3 components of a float
// return 1 if it is NaN, 0 otherwise
int is_nan(float_components_t f) {

// NaN is when float is all 1's and exponent is just 1.
    if (f.exponent == 0xFF && f.fraction != 0) {
        return 1;
    }
    return 0;
}

// given the 3 components of a float
// return 1 if it is inf, 0 otherwise
int is_positive_infinity(float_components_t f) {
    
    // exponent is all 1 and the fraction is 0 and the sign is 0 cos positive
    if (f.sign == 0 && f.exponent == 0xFF && f.fraction == 0) {
        return 1;
    }
    return 0;
}

// given the 3 components of a float
// return 1 if it is -inf, 0 otherwise
int is_negative_infinity(float_components_t f) {
    // exponent is all 1 and the fraction is 0 and the sign is 1 cos negative
    if (f.sign == 1 && f.exponent == 0xFF && f.fraction == 0) {
        return 1;
    }
    return 0;
}

// given the 3 components of a float
// return 1 if it is 0 or -0, 0 otherwise
int is_zero(float_components_t f) {
    // everything is 0 but the sign doesnt matter. we can hae -0.
    if (f.exponent == 0 && f.fraction == 0) {
        return 1;
    }
    return 0;
}
