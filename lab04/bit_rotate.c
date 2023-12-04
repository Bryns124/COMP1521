#include "bit_rotate.h"

// return the value bits rotated left n_rotations
uint16_t bit_rotate(int n_rotations, uint16_t bits) {
    
    uint16_t rotatedLeft = 0;
    uint16_t rotatedRight = 0;
    
    if (n_rotations >= 0 && n_rotations <= 16) {
        uint16_t lostBits = (bits << n_rotations);
        uint16_t returnBits = (bits >> (16 - n_rotations));
        rotatedLeft = (lostBits | returnBits);
        return rotatedLeft;
    }
    else if (n_rotations > 16) {
        int shift = n_rotations % 16;
        uint16_t lostBits = (bits << shift);
        uint16_t returnBits = (bits >> (16 - shift));
        rotatedLeft = (lostBits | returnBits);
        return rotatedLeft;
    }
    else if (n_rotations < 0) {
        int shift = (-1*n_rotations) % 16;
        uint16_t lostBits = (bits >> shift);
        uint16_t returnBits = (bits << (16 - shift));
        rotatedRight = (lostBits | returnBits);
    }
    return rotatedRight;
}
