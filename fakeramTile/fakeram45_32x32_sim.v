module fakeram45_32x32 (
    input  wire [4:0]  addr_in,
    input  wire [31:0] wd_in,
    input  wire [31:0] w_mask_in,
    input  wire        we_in,
    input  wire        ce_in,
    input  wire        clk,
    output reg  [31:0] rd_out
);

    reg [31:0] mem [0:31];

    always @(posedge clk) begin
        if (ce_in) begin
            if (we_in) begin
                mem[addr_in] <= (wd_in & w_mask_in) | (mem[addr_in] & ~w_mask_in);
            end else begin
                rd_out <= mem[addr_in];
            end
        end
    end
endmodule
