import math
import os

SRAM_CONFIGS = [
    (6, 86),
    (6, 108),
    (6, 512),
    (7, 29),
    (7, 128),
]

FAKERAM_DEPTH = 32
FAKERAM_AW = 5 # Address Width
FAKERAM_DW = 32

DEFAULT_SRAM_CONFIGS = SRAM_CONFIGS

def generate_ff_mem_sv(addr_w: int, data_w: int, out_path: str):
    depth = 2 ** addr_w
    with open(out_path, 'w') as f:
        f.write(f"module sram_1p_a{addr_w}_d{data_w} #(\n")
        f.write(f"    parameter ADDR_WIDTH = {addr_w},\n")
        f.write(f"    parameter DATA_WIDTH = {data_w}\n")
        f.write(f") (\n")
        f.write(f"    input  wire [ADDR_WIDTH-1:0] A,\n")
        f.write(f"    input  wire [DATA_WIDTH-1:0] DI,\n")
        f.write(f"    input  wire [DATA_WIDTH-1:0] BW,\n")
        f.write(f"    input  wire                  CLK,\n")
        f.write(f"    input  wire                  CE,\n")
        f.write(f"    input  wire                  RDWEN,\n")
        f.write(f"    output reg  [DATA_WIDTH-1:0] DO\n")
        f.write(f");\n\n")
        f.write(f"    reg [DATA_WIDTH-1:0] mem [0:{depth-1}];\n\n")
        f.write(f"    always_ff @(posedge CLK) begin\n")
        f.write(f"        if (CE) begin\n")
        f.write(f"            if (!RDWEN) begin // Write\n")
        f.write(f"                mem[A] <= (DI & BW) | (mem[A] & ~BW);\n")
        f.write(f"            end else begin // Read\n")
        f.write(f"                DO <= mem[A];\n")
        f.write(f"            end\n")
        f.write(f"        end\n")
        f.write(f"    end\n")
        f.write(f"endmodule\n")

FAKERAM_BB_V = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'fakeram45_32x32_bb.v')

def generate_composed_sram_sv(addr_w, data_w, out_path):
    name = f"sram_1p_a{addr_w}_d{data_w}"
    depth = 2 ** addr_w
    n_rows = math.ceil(depth / FAKERAM_DEPTH)
    n_cols = math.ceil(data_w / FAKERAM_DW)
    last_col_bits = data_w - (n_cols - 1) * FAKERAM_DW

    with open(out_path, 'w') as f:
        f.write(f"// Auto-generated: {name} composed from "
                f"{n_rows}x{n_cols} fakeram45_32x32 instances\n")
        f.write(f"module {name} #(\n")
        f.write(f"    parameter ADDR_WIDTH = {addr_w},\n")
        f.write(f"    parameter DATA_WIDTH = {data_w}\n")
        f.write(f") (\n")
        f.write(f"    input  wire [ADDR_WIDTH-1:0] A,\n")
        f.write(f"    input  wire [DATA_WIDTH-1:0] DI,\n")
        f.write(f"    input  wire [DATA_WIDTH-1:0] BW,\n")
        f.write(f"    input  wire                  CLK,\n")
        f.write(f"    input  wire                  CE,\n")
        f.write(f"    input  wire                  RDWEN,\n")
        f.write(f"    output wire [DATA_WIDTH-1:0] DO\n")
        f.write(f");\n\n")

        f.write(f"    wire we = ~RDWEN;\n\n")

        if addr_w > FAKERAM_AW:
            f.write(f"    wire [{FAKERAM_AW-1}:0] sub_addr = "
                    f"A[{FAKERAM_AW-1}:0];\n")
            row_sel_w = addr_w - FAKERAM_AW
            f.write(f"    wire [{row_sel_w-1}:0] row_sel  = "
                    f"A[{addr_w-1}:{FAKERAM_AW}];\n\n")
        elif addr_w == FAKERAM_AW:
            f.write(f"    wire [{FAKERAM_AW-1}:0] sub_addr = A;\n\n")
            row_sel_w = 0
        else:
            pad = FAKERAM_AW - addr_w
            f.write(f"    wire [{FAKERAM_AW-1}:0] sub_addr = "
                    f"{{{pad}'b0, A}};\n\n")
            row_sel_w = 0

        for r in range(n_rows):
            for c in range(n_cols):
                f.write(f"    wire [{FAKERAM_DW-1}:0] rd_{r}_{c};\n")
        f.write("\n")

        if n_rows > 1:
            for r in range(n_rows):
                f.write(f"    wire ce_{r} = CE & "
                        f"(row_sel == {row_sel_w}'d{r});\n")
            f.write("\n")

        for r in range(n_rows):
            for c in range(n_cols):
                inst = f"u_ram_r{r}_c{c}"
                lo = c * FAKERAM_DW
                hi = min((c + 1) * FAKERAM_DW, data_w) - 1
                col_bits = hi - lo + 1

                if col_bits == FAKERAM_DW:
                    wd_expr = f"DI[{hi}:{lo}]"
                else:
                    pad = FAKERAM_DW - col_bits
                    wd_expr = f"{{{pad}'b0, DI[{hi}:{lo}]}}"

                if col_bits == FAKERAM_DW:
                    wm_expr = f"BW[{hi}:{lo}]"
                else:
                    pad = FAKERAM_DW - col_bits
                    wm_expr = f"{{{pad}'b0, BW[{hi}:{lo}]}}"

                ce_expr = f"ce_{r}" if n_rows > 1 else "CE"

                f.write(f"    fakeram45_32x32 {inst} (\n")
                f.write(f"        .addr_in   (sub_addr),\n")
                f.write(f"        .wd_in     ({wd_expr}),\n")
                f.write(f"        .w_mask_in ({wm_expr}),\n")
                f.write(f"        .we_in     (we),\n")
                f.write(f"        .ce_in     ({ce_expr}),\n")
                f.write(f"        .clk       (CLK),\n")
                f.write(f"        .rd_out    (rd_{r}_{c})\n")
                f.write(f"    );\n\n")

        if n_rows > 1:
            f.write(f"    reg [{row_sel_w-1}:0] row_sel_r;\n")
            f.write(f"    always @(posedge CLK) begin\n")
            f.write(f"        if (CE && RDWEN)\n")
            f.write(f"            row_sel_r <= row_sel;\n")
            f.write(f"    end\n\n")

            for c in range(n_cols):
                lo = c * FAKERAM_DW
                hi = min((c + 1) * FAKERAM_DW, data_w) - 1
                col_bits = hi - lo + 1
                f.write(f"    reg [{FAKERAM_DW-1}:0] rd_mux_{c};\n")
                f.write(f"    always @(*) begin\n")
                f.write(f"        case (row_sel_r)\n")
                for r in range(n_rows):
                    f.write(f"            {row_sel_w}'d{r}: "
                            f"rd_mux_{c} = rd_{r}_{c};\n")
                f.write(f"            default: rd_mux_{c} = "
                        f"{FAKERAM_DW}'d0;\n")
                f.write(f"        endcase\n")
                f.write(f"    end\n\n")

            parts = []
            for c in reversed(range(n_cols)):
                lo = c * FAKERAM_DW
                hi = min((c + 1) * FAKERAM_DW, data_w) - 1
                col_bits = hi - lo + 1
                if col_bits == FAKERAM_DW:
                    parts.append(f"rd_mux_{c}")
                else:
                    parts.append(f"rd_mux_{c}[{col_bits-1}:0]")
            if len(parts) == 1:
                f.write(f"    assign DO = {parts[0]};\n\n")
            else:
                f.write(f"    assign DO = {{{', '.join(parts)}}};\n\n")
        else:
            parts = []
            for c in reversed(range(n_cols)):
                lo = c * FAKERAM_DW
                hi = min((c + 1) * FAKERAM_DW, data_w) - 1
                col_bits = hi - lo + 1
                if col_bits == FAKERAM_DW:
                    parts.append(f"rd_0_{c}")
                else:
                    parts.append(f"rd_0_{c}[{col_bits-1}:0]")
            if len(parts) == 1:
                f.write(f"    assign DO = {parts[0]};\n\n")
            else:
                f.write(f"    assign DO = {{{', '.join(parts)}}};\n\n")

        f.write(f"endmodule\n")
    return out_path

def generate_sram_wrapper_1p(configs, out_path):
    with open(out_path, 'w') as f:
        f.write("module asic_sram_1p #(\n")
        f.write("    parameter ADDR_WIDTH = 1,\n")
        f.write("    parameter DATA_WIDTH = 1\n")
        f.write(") (\n")
        f.write("    input  wire [ADDR_WIDTH-1:0] A,\n")
        f.write("    input  wire [DATA_WIDTH-1:0] DI,\n")
        f.write("    input  wire [DATA_WIDTH-1:0] BW,\n")
        f.write("    input  wire                  CLK,\n")
        f.write("    input  wire                  CE,\n")
        f.write("    input  wire                  RDWEN,\n")
        f.write("    output wire [DATA_WIDTH-1:0] DO\n")
        f.write(");\n\n")
        f.write("generate\n")
        for i, (aw, dw) in enumerate(sorted(configs)):
            name = f"sram_1p_a{aw}_d{dw}"
            startif = "    if"
            if i != 0:
                startif = "    else if"
            f.write(f"{startif} (ADDR_WIDTH == {aw} && DATA_WIDTH == {dw}) ")
            f.write(f"begin : gen_{name}\n")
            f.write(f"        {name} sram (\n")
            f.write(f"            .A     (A),\n")
            f.write(f"            .DI    (DI),\n")
            f.write(f"            .BW    (BW),\n")
            f.write(f"            .CLK   (CLK),\n")
            f.write(f"            .CE    (CE),\n")
            f.write(f"            .RDWEN (RDWEN),\n")
            f.write(f"            .DO    (DO)\n")
            f.write(f"        );\n")
            f.write(f"    end\n")
        f.write("endgenerate\n\n")
        f.write("endmodule\n")

def generate_top_tile(configs, out_path):
    max_aw = max(aw for aw, _ in configs)
    max_dw = max(dw for _, dw in configs)
    n_mem = len(configs)
    sel_w = max(1, (n_mem - 1).bit_length())

    with open(out_path, 'w') as f:
        f.write(f"module top_tile (\n")
        f.write(f"    input  wire                       clk,\n")
        f.write(f"    input  wire                       rstn,\n")
        f.write(f"    input  wire [{sel_w-1}:0]              sel,\n")
        f.write(f"    input  wire                       ce,\n")
        f.write(f"    input  wire                       rdwen,\n")
        f.write(f"    input  wire [{max_aw-1}:0]             addr_in,\n")
        f.write(f"    input  wire [{max_dw-1}:0]  data_in,\n")
        f.write(f"    input  wire [{max_dw-1}:0]  bw_in,\n")
        f.write(f"    output reg  [{max_dw-1}:0]  data_out\n")
        f.write(f");\n\n")

        for idx, (aw, dw) in enumerate(configs):
            f.write(f"    wire [{dw-1}:0] do_{idx};\n")
        f.write("\n")

        for idx, (aw, dw) in enumerate(configs):
            inst = f"u_sram_{idx}_a{aw}_d{dw}"
            f.write(f"    asic_sram_1p #(\n")
            f.write(f"        .ADDR_WIDTH({aw}),\n")
            f.write(f"        .DATA_WIDTH({dw})\n")
            f.write(f"    ) {inst} (\n")
            f.write(f"        .A     (addr_in[{aw-1}:0]),\n")
            f.write(f"        .DI    (data_in[{dw-1}:0]),\n")
            f.write(f"        .BW    (bw_in[{dw-1}:0]),\n")
            f.write(f"        .CLK   (clk),\n")
            f.write(f"        .CE    (ce),\n")
            f.write(f"        .RDWEN (rdwen),\n")
            f.write(f"        .DO    (do_{idx})\n")
            f.write(f"    );\n\n")

        f.write(f"    always @(*) begin\n")
        f.write(f"        data_out = {max_dw}'d0;\n")
        f.write(f"        case (sel)\n")
        for idx, (aw, dw) in enumerate(configs):
            pad = max_dw - dw
            if pad > 0:
                f.write(f"            {sel_w}'d{idx}: data_out = {{{pad}'d0, do_{idx}}};\n")
            else:
                f.write(f"            {sel_w}'d{idx}: data_out = do_{idx};\n")
        f.write(f"            default: data_out = {max_dw}'d0;\n")
        f.write(f"        endcase\n")
        f.write(f"    end\n\n")
        f.write(f"endmodule\n")

def generate_sram_verilog(config, output_dir):
    os.makedirs(output_dir, exist_ok=True)
    generated = {'sram_files': [], 'wrapper': None, 'top_tile': None}
    for aw, dw in config:
        sv = os.path.join(output_dir, f"sram_1p_a{aw}_d{dw}.sv")
        generate_ff_mem_sv(aw, dw, sv)
        generated['sram_files'].append(sv)
    wrapper = os.path.join(output_dir, 'asic_sram_1p.v')
    generate_sram_wrapper_1p(config, wrapper)
    generated['wrapper'] = wrapper
    top = os.path.join(output_dir, 'top_tile.sv')
    generate_top_tile(config, top)
    generated['top_tile'] = top
    return generated

def generate_sram_verilog_macro(config = SRAM_CONFIGS, output_dir='build/sram_gen'):
    os.makedirs(output_dir, exist_ok=True)
    generated = {
        'sram_files': [],
        'bb_file': None,
        'wrapper': None,
        'top_tile': None,
    }
    generated['bb_file'] = FAKERAM_BB_V
    for aw, dw in config:
        sv = os.path.join(output_dir, f"sram_1p_a{aw}_d{dw}.sv")
        generate_composed_sram_sv(aw, dw, sv)
        generated['sram_files'].append(sv)
    wrapper = os.path.join(output_dir, 'asic_sram_1p.v')
    generate_sram_wrapper_1p(config, wrapper)
    generated['wrapper'] = wrapper
    top = os.path.join(output_dir, 'top_tile.sv')
    generate_top_tile(config, top)
    generated['top_tile'] = top
    return generated



