/* -----------------------------------------------
* File           : sp_ram_asic.sv
* Organization   : Barcelona Supercomputing Center
* Author(s)      : Junaid Ahmed; Xabier Abancens
* Email(s)       : {author}@bsc.es
* References     : Openpiton
* https://github.com/PrincetonUniversity/openpiton
* -----------------------------------------------
* Revision History
*  Revision   | Author          |  Description
*  0.1        | Junaid Ahmed;   |
*             | Xabier Abancens |
*  0.2        | (auto)          | Simplified for generic ASIC flow — delegates
*             |                 | to asic_sram_1p blackbox instead of
*             |                 | technology-specific macros.
* -----------------------------------------------
*/

// Single port RAM module — generic ASIC target.
// Instantiates the technology-independent asic_sram_1p blackbox.

module sp_ram_asic #(
    parameter ADDR_WIDTH=1,
    parameter DATA_WIDTH=1
) (
   `ifdef INTEL_PHYSICAL_MEM_CTRL
   input wire  [27:0]               INTEL_MEM_CTRL,
   `endif
   input wire  [ADDR_WIDTH-1  : 0]  A,
   input wire  [DATA_WIDTH-1  : 0]  DI,
   input wire  [DATA_WIDTH-1  : 0]  BW,
   input wire  CLK,CE, RDWEN,  // RDWEN: 1=WR and 0=RD
   output wire [DATA_WIDTH-1  : 0]  DO
);

    asic_sram_1p #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) sram (
        .A     (A),
        .DI    (DI),
        .BW    (BW),
        .CLK   (CLK),
        .CE    (CE),
        .RDWEN (RDWEN),
        .DO    (DO)
    );

endmodule
