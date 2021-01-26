
#include <stdint.h>
#include "bp_utils.h"

// This test requires manual verification to see if the cache is actually flushing
// Additionally, this will cause problems in cosim since there is no l2 cache model

int main(int argc, char** argv) {

    uint64_t code_base = 0x80000000;
    uint64_t data_base = 0x81000000;
    uint64_t block_shift  = 6;

    for (int i = 0; i < 10000; i++) {
        *(uint64_t*)(data_base + (i << block_shift)) = i;
    }

    for (int i = 0; i < 10000; i++) {
        uint64_t x = *(uint64_t*)(data_base + (i << block_shift));
    }

    bp_finish(0);

    return 0;
}
