(* blackbox *)
module asic_sram_1p #(
    parameter ADDR_WIDTH = 1,
    parameter DATA_WIDTH = 1
) (
    input  wire [ADDR_WIDTH-1:0] A,
    input  wire [DATA_WIDTH-1:0] DI,
    input  wire [DATA_WIDTH-1:0] BW,
    input  wire                  CLK,
    input  wire                  CE,
    input  wire                  RDWEN,
    output wire [DATA_WIDTH-1:0] DO
);
endmodule
