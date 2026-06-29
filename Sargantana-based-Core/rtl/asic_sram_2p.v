(* blackbox *)
module asic_sram_2p #(
    parameter ADDR_WIDTH = 1,
    parameter DATA_WIDTH = 1
) (
    input  wire [ADDR_WIDTH-1:0] AA,   // Read address
    input  wire [ADDR_WIDTH-1:0] AB,   // Write address
    input  wire [DATA_WIDTH-1:0] DB,   // Write data
    input  wire [DATA_WIDTH-1:0] BWB,  // Write bit-mask
    input  wire                  CLKA, // Read clock
    input  wire                  CEA,  // Read enable
    input  wire                  CLKB, // Write clock
    input  wire                  CEB,  // Write enable
    output wire [DATA_WIDTH-1:0] QA    // Read data
);
endmodule
