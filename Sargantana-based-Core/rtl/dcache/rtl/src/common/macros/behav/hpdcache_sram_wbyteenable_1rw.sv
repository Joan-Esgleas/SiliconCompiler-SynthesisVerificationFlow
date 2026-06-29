/*
 *  Copyright 2023 CEA*
 *  *Commissariat a l'Energie Atomique et aux Energies Alternatives (CEA)
 *
 *  SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
 *
 *  Licensed under the Solderpad Hardware License v 2.1 (the “License”); you
 *  may not use this file except in compliance with the License, or, at your
 *  option, the Apache License version 2.0. You may obtain a copy of the
 *  License at
 *
 *  https://solderpad.org/licenses/SHL-2.1/
 *
 *  Unless required by applicable law or agreed to in writing, any work
 *  distributed under the License is distributed on an “AS IS” BASIS, WITHOUT
 *  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 *  License for the specific language governing permissions and limitations
 *  under the License.
 */
/*
 *  Authors       : Cesar Fuguet
 *  Creation Date : March, 2020
 *  Description   : Behavioral model of a 1RW SRAM with write byte enable
 *  History       :
 */
module hpdcache_sram_wbyteenable_1rw
#(
    parameter int unsigned ADDR_SIZE = 0,
    parameter int unsigned DATA_SIZE = 0,
    parameter int unsigned DEPTH = 2**ADDR_SIZE
)
(
    input  logic                   clk,
    input  logic                   rst_n,
    input  logic                   cs,
    input  logic                   we,
    input  logic [ADDR_SIZE-1:0]   addr,
    input  logic [DATA_SIZE-1:0]   wdata,
    input  logic [DATA_SIZE/8-1:0] wbyteenable,
    output logic [DATA_SIZE-1:0]   rdata
);

`ifdef SRAM_IP
    //  ASIC path — use the generic single-port SRAM blackbox.
    //  Convert byte-enable to bit-mask (replicate each byte-enable bit 8×).
    logic [DATA_SIZE-1:0] bitmask;
    genvar g;
    generate
        for (g = 0; g < DATA_SIZE/8; g = g + 1) begin : gen_bitmask
            assign bitmask[g*8 +: 8] = {8{wbyteenable[g]}};
        end
    endgenerate

    asic_sram_1p #(
        .ADDR_WIDTH  (ADDR_SIZE),
        .DATA_WIDTH  (DATA_SIZE)
    ) u_sram (
        .CLK   (clk),
        .CE    (cs),
        .RDWEN (we),
        .A     (addr),
        .DI    (wdata),
        .BW    (bitmask),
        .DO    (rdata)
    );
`else
    /*
     *  Internal memory array declaration
     */
    typedef logic [DATA_SIZE-1:0] mem_t [DEPTH];
    mem_t mem;

    /*
     *  Process to update or read the memory array
     */
    always_ff @(posedge clk)
    begin : mem_update_ff
        if (cs == 1'b1) begin
            if (we == 1'b1) begin
                for (int i = 0; i < DATA_SIZE/8; i++) begin
                    if (wbyteenable[i]) mem[addr][i*8 +: 8] <= wdata[i*8 +: 8];
                end
            end
            rdata <= mem[addr];
        end
    end : mem_update_ff
`endif
endmodule : hpdcache_sram_wbyteenable_1rw
