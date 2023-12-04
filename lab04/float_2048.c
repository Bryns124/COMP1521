// Multiply a float by 2048 using bit operations only

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#include "floats.h"

// float_2048 is given the bits of a float f as a uint32_t
// it uses bit operations and + to calculate f * 2048
// and returns the bits of this value as a uint32_t
//
// if the result is too large to be represented as a float +inf or -inf is returned
//
// if f is +0, -0, +inf or -inf, or Nan it is returned unchanged
//
// float_2048 assumes f is not a denormal number
//
uint32_t float_2048(uint32_t f) {
    
    uint32_t sign = f >> 31;
    int maskExponent = 0b01111111100000000000000000000000;
    uint32_t exponent = (f & maskExponent) >> 23;
    int maskFraction = 0b00000000011111111111111111111111;
    uint32_t fraction = (f & maskFraction);
    // add 11 to exponent. check if its become bigger than 0xFF. if too large manually return infinity by returning 

    return (f << 11);
}
