// Auto-generated Verilator main for SiliconCompiler DVFlow
#include "verilated.h"

// Forward-declare the top module (Verilator generates the class header)
#if __has_include("Vsim_top.h")
#include "Vsim_top.h"
#define TOP_CLASS Vsim_top
#elif __has_include("Vtop_tile.h")
#include "Vtop_tile.h"
#define TOP_CLASS Vtop_tile
#else
#error "Cannot find Verilator-generated top header"
#endif

int main(int argc, char** argv, char** env) {
    VerilatedContext* const contextp = new VerilatedContext;
    contextp->commandArgs(argc, argv);

    TOP_CLASS* const topp = new TOP_CLASS{contextp};

    while (!contextp->gotFinish()) {
        topp->eval_step();
        topp->eval_end_step();
    }

    topp->final();
    delete topp;
    delete contextp;
    return 0;
}
