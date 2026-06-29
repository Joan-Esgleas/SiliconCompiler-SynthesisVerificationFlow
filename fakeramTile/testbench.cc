#include <cstdlib>
#include <cstdio>
#include <cstdint>
#include "verilated.h"
#include "Vtop_tile.h"

static vluint64_t sim_time = 0;


static void tick(Vtop_tile *dut) {
    dut->clk = 0; dut->eval();
    sim_time++;
    dut->clk = 1; dut->eval();
    sim_time++;
}


static uint32_t mask_word(uint32_t val, int word, int nwords, int data_bits) {
    if (word == nwords - 1) {
        int bits = data_bits - 32 * word;
        if (bits < 32) val &= (1ULL << bits) - 1;
    }
    return val;
}

#define ARRLEN(a) (int)(sizeof(a)/sizeof(a[0]))


struct BankCfg { int sel, addr_bits, data_bits; };

static const BankCfg banks[] = {
    {0, 6,  86}, {1, 6, 108}, {2, 6, 512},
    {3, 7,  29}, {4, 7, 128},
};
static const int NUM_BANKS  = ARRLEN(banks);
static const int TEST_ADDRS = 8;


int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    Vtop_tile *dut = new Vtop_tile;
    int errors = 0;

    dut->rstn = 0; dut->ce = 0; dut->rdwen = 1; dut->sel = 0; dut->addr_in = 0;
    for (int w = 0; w < ARRLEN(dut->data_in); w++) {
        dut->data_in[w] = 0;
        dut->bw_in[w]   = 0;
    }
    tick(dut); tick(dut);
    dut->rstn = 1;
    tick(dut);

    for (int b = 0; b < NUM_BANKS; b++) {
        const BankCfg &cfg = banks[b];
        int naddrs = std::min(TEST_ADDRS, 1 << cfg.addr_bits);
        int nwords = (cfg.data_bits + 31) / 32;

        printf("[bank %d] sel=%d  addr=%d  data=%d  dirs=%d\n",
               b, cfg.sel, cfg.addr_bits, cfg.data_bits, naddrs);
        for (int a = 0; a < naddrs; a++) {
        dut->sel = cfg.sel;
        dut->ce = 1;
        dut->rdwen = 0;
        dut->addr_in = a;

        for (int w = 0; w < ARRLEN(dut->bw_in); w++) dut->bw_in[w] = 0xFFFFFFFFu;

        uint32_t seed = 0x10000000u ^ ((uint32_t)cfg.sel << 20) ^ (uint32_t)a;
        for (int w = 0; w < ARRLEN(dut->data_in); w++) {
            uint32_t val = seed + 0x11111111u * (uint32_t)w;
            dut->data_in[w] = (w < nwords) ? mask_word(val, w, nwords, cfg.data_bits) : 0;
        }
        tick(dut);
    }
    dut->ce = 0;
    tick(dut);

    for (int a = 0; a < naddrs; a++) {
        dut->sel = cfg.sel;
        dut->ce = 1;
        dut->rdwen = 1;   // read
        dut->addr_in = a;
        tick(dut);

        uint32_t seed = 0x10000000u ^ ((uint32_t)cfg.sel << 20) ^ (uint32_t)a;
        for (int w = 0; w < nwords; w++) {
            uint32_t exp = mask_word(seed + 0x11111111u * (uint32_t)w, w, nwords, cfg.data_bits);
            uint32_t got = mask_word(dut->data_out[w], w, nwords, cfg.data_bits);
            if (got != exp) {
                errors++;
                printf("ERR bank=%d addr=%d word=%d exp=%08x got=%08x\n",
                    cfg.sel, a, w, exp, got);
            }
        }
    }
        dut->ce = 0; tick(dut);
    }

    printf(errors ? "\n*** TEST FAILED *** (%d errors)\n"
                  : "\n*** TEST PASSED ***\n", errors);

    dut->final();
    delete dut;
    return errors ? 1 : 0;
}
