(* blackbox *)
module fakeram45_32x32 (
    input  wire [4:0]  addr_in,
    input  wire [31:0] wd_in,
    input  wire [31:0] w_mask_in,
    input  wire        we_in,
    input  wire        ce_in,
    input  wire        clk,
    output wire [31:0] rd_out
);
endmodule
