/* -----------------------------------------------
* File           : dp_ram_asic.sv
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
* -----------------------------------------------
*/

// Dual port RAM module — generic ASIC target.

module dp_ram_asic #(
    parameter ADDR_WIDTH=1,
    parameter DATA_WIDTH=1
) (
   `ifdef INTEL_PHYSICAL_MEM_CTRL
   input wire [27:0]               INTEL_MEM_CTRL,
   `endif
   input wire [ADDR_WIDTH-1  : 0]  AA,AB,
   input wire [DATA_WIDTH-1  : 0]  DB,
   input wire [DATA_WIDTH-1  : 0]  BWB,
   input wire CLKA,CEA,
   input wire CLKB,CEB,
   output wire [DATA_WIDTH-1  : 0]  QA
);

    asic_sram_2p #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) sram (
        .AA    (AA),
        .AB    (AB),
        .DB    (DB),
        .BWB   (BWB),
        .CLKA  (CLKA),
        .CEA   (CEA),
        .CLKB  (CLKB),
        .CEB   (CEB),
        .QA    (QA)
    );

endmodule
