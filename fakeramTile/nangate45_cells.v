module AND2_X1 (A1, A2, ZN);
    input A1;
    input A2;
    output ZN;
    assign ZN = A1 & A2;
endmodule

module AND2_X2 (A1, A2, ZN);
    input A1;
    input A2;
    output ZN;
    assign ZN = A1 & A2;
endmodule

module AND2_X4 (A1, A2, ZN);
    input A1;
    input A2;
    output ZN;
    assign ZN = A1 & A2;
endmodule

module AND3_X1 (A1, A2, A3, ZN);
    input A1;
    input A2;
    input A3;
    output ZN;
    assign ZN = A1 & A2 & A3;
endmodule

module AND3_X2 (A1, A2, A3, ZN);
    input A1;
    input A2;
    input A3;
    output ZN;
    assign ZN = A1 & A2 & A3;
endmodule

module AND3_X4 (A1, A2, A3, ZN);
    input A1;
    input A2;
    input A3;
    output ZN;
    assign ZN = A1 & A2 & A3;
endmodule

module AND4_X1 (A1, A2, A3, A4, ZN);
    input A1;
    input A2;
    input A3;
    input A4;
    output ZN;
    assign ZN = A1 & A2 & A3 & A4;
endmodule

module AND4_X2 (A1, A2, A3, A4, ZN);
    input A1;
    input A2;
    input A3;
    input A4;
    output ZN;
    assign ZN = A1 & A2 & A3 & A4;
endmodule

module AND4_X4 (A1, A2, A3, A4, ZN);
    input A1;
    input A2;
    input A3;
    input A4;
    output ZN;
    assign ZN = A1 & A2 & A3 & A4;
endmodule

module OR2_X1 (A1, A2, ZN);
    input A1;
    input A2;
    output ZN;
    assign ZN = A1 | A2;
endmodule

module OR2_X2 (A1, A2, ZN);
    input A1;
    input A2;
    output ZN;
    assign ZN = A1 | A2;
endmodule

module OR2_X4 (A1, A2, ZN);
    input A1;
    input A2;
    output ZN;
    assign ZN = A1 | A2;
endmodule

module OR3_X1 (A1, A2, A3, ZN);
    input A1;
    input A2;
    input A3;
    output ZN;
    assign ZN = A1 | A2 | A3;
endmodule

module OR3_X2 (A1, A2, A3, ZN);
    input A1;
    input A2;
    input A3;
    output ZN;
    assign ZN = A1 | A2 | A3;
endmodule

module OR3_X4 (A1, A2, A3, ZN);
    input A1;
    input A2;
    input A3;
    output ZN;
    assign ZN = A1 | A2 | A3;
endmodule

module OR4_X1 (A1, A2, A3, A4, ZN);
    input A1;
    input A2;
    input A3;
    input A4;
    output ZN;
    assign ZN = A1 | A2 | A3 | A4;
endmodule

module OR4_X2 (A1, A2, A3, A4, ZN);
    input A1;
    input A2;
    input A3;
    input A4;
    output ZN;
    assign ZN = A1 | A2 | A3 | A4;
endmodule

module OR4_X4 (A1, A2, A3, A4, ZN);
    input A1;
    input A2;
    input A3;
    input A4;
    output ZN;
    assign ZN = A1 | A2 | A3 | A4;
endmodule

module NAND2_X1 (A1, A2, ZN);
    input A1;
    input A2;
    output ZN;
    assign ZN = ~(A1 & A2);
endmodule

module NAND2_X2 (A1, A2, ZN);
    input A1;
    input A2;
    output ZN;
    assign ZN = ~(A1 & A2);
endmodule

module NAND2_X4 (A1, A2, ZN);
    input A1;
    input A2;
    output ZN;
    assign ZN = ~(A1 & A2);
endmodule

module NAND3_X1 (A1, A2, A3, ZN);
    input A1;
    input A2;
    input A3;
    output ZN;
    assign ZN = ~(A1 & A2 & A3);
endmodule

module NAND3_X2 (A1, A2, A3, ZN);
    input A1;
    input A2;
    input A3;
    output ZN;
    assign ZN = ~(A1 & A2 & A3);
endmodule

module NAND3_X4 (A1, A2, A3, ZN);
    input A1;
    input A2;
    input A3;
    output ZN;
    assign ZN = ~(A1 & A2 & A3);
endmodule

module NAND4_X1 (A1, A2, A3, A4, ZN);
    input A1;
    input A2;
    input A3;
    input A4;
    output ZN;
    assign ZN = ~(A1 & A2 & A3 & A4);
endmodule

module NAND4_X2 (A1, A2, A3, A4, ZN);
    input A1;
    input A2;
    input A3;
    input A4;
    output ZN;
    assign ZN = ~(A1 & A2 & A3 & A4);
endmodule

module NAND4_X4 (A1, A2, A3, A4, ZN);
    input A1;
    input A2;
    input A3;
    input A4;
    output ZN;
    assign ZN = ~(A1 & A2 & A3 & A4);
endmodule

module NOR2_X1 (A1, A2, ZN);
    input A1;
    input A2;
    output ZN;
    assign ZN = ~(A1 | A2);
endmodule

module NOR2_X2 (A1, A2, ZN);
    input A1;
    input A2;
    output ZN;
    assign ZN = ~(A1 | A2);
endmodule

module NOR2_X4 (A1, A2, ZN);
    input A1;
    input A2;
    output ZN;
    assign ZN = ~(A1 | A2);
endmodule

module NOR3_X1 (A1, A2, A3, ZN);
    input A1;
    input A2;
    input A3;
    output ZN;
    assign ZN = ~(A1 | A2 | A3);
endmodule

module NOR3_X2 (A1, A2, A3, ZN);
    input A1;
    input A2;
    input A3;
    output ZN;
    assign ZN = ~(A1 | A2 | A3);
endmodule

module NOR3_X4 (A1, A2, A3, ZN);
    input A1;
    input A2;
    input A3;
    output ZN;
    assign ZN = ~(A1 | A2 | A3);
endmodule

module NOR4_X1 (A1, A2, A3, A4, ZN);
    input A1;
    input A2;
    input A3;
    input A4;
    output ZN;
    assign ZN = ~(A1 | A2 | A3 | A4);
endmodule

module NOR4_X2 (A1, A2, A3, A4, ZN);
    input A1;
    input A2;
    input A3;
    input A4;
    output ZN;
    assign ZN = ~(A1 | A2 | A3 | A4);
endmodule

module NOR4_X4 (A1, A2, A3, A4, ZN);
    input A1;
    input A2;
    input A3;
    input A4;
    output ZN;
    assign ZN = ~(A1 | A2 | A3 | A4);
endmodule

module INV_X1 (A, ZN);
    input A;
    output ZN;
    assign ZN = ~A;
endmodule

module INV_X2 (A, ZN);
    input A;
    output ZN;
    assign ZN = ~A;
endmodule

module INV_X4 (A, ZN);
    input A;
    output ZN;
    assign ZN = ~A;
endmodule

module BUF_X1 (A, Z);
    input A;
    output Z;
    assign Z = A;
endmodule

module BUF_X2 (A, Z);
    input A;
    output Z;
    assign Z = A;
endmodule

module BUF_X4 (A, Z);
    input A;
    output Z;
    assign Z = A;
endmodule

module CLKBUF_X1 (A, Z);
    input A;
    output Z;
    assign Z = A;
endmodule

module CLKBUF_X2 (A, Z);
    input A;
    output Z;
    assign Z = A;
endmodule

module CLKBUF_X4 (A, Z);
    input A;
    output Z;
    assign Z = A;
endmodule

module AOI21_X1 (A, B1, B2, ZN);
    input A;
    input B1;
    input B2;
    output ZN;
    assign ZN = ~((B1 & B2) | A);
endmodule

module AOI21_X2 (A, B1, B2, ZN);
    input A;
    input B1;
    input B2;
    output ZN;
    assign ZN = ~((B1 & B2) | A);
endmodule

module AOI21_X4 (A, B1, B2, ZN);
    input A;
    input B1;
    input B2;
    output ZN;
    assign ZN = ~((B1 & B2) | A);
endmodule

module AOI22_X1 (A1, A2, B1, B2, ZN);
    input A1;
    input A2;
    input B1;
    input B2;
    output ZN;
    assign ZN = ~((A1 & A2) | (B1 & B2));
endmodule

module AOI22_X2 (A1, A2, B1, B2, ZN);
    input A1;
    input A2;
    input B1;
    input B2;
    output ZN;
    assign ZN = ~((A1 & A2) | (B1 & B2));
endmodule

module AOI22_X4 (A1, A2, B1, B2, ZN);
    input A1;
    input A2;
    input B1;
    input B2;
    output ZN;
    assign ZN = ~((A1 & A2) | (B1 & B2));
endmodule

module AOI211_X1 (A, B, C1, C2, ZN);
    input A;
    input B;
    input C1;
    input C2;
    output ZN;
    assign ZN = ~((C1 & C2) | A | B);
endmodule

module AOI211_X2 (A, B, C1, C2, ZN);
    input A;
    input B;
    input C1;
    input C2;
    output ZN;
    assign ZN = ~((C1 & C2) | A | B);
endmodule

module AOI211_X4 (A, B, C1, C2, ZN);
    input A;
    input B;
    input C1;
    input C2;
    output ZN;
    assign ZN = ~((C1 & C2) | A | B);
endmodule

module AOI221_X1 (A, B1, B2, C1, C2, ZN);
    input A;
    input B1;
    input B2;
    input C1;
    input C2;
    output ZN;
    assign ZN = ~((B1 & B2) | (C1 & C2) | A);
endmodule

module AOI221_X2 (A, B1, B2, C1, C2, ZN);
    input A;
    input B1;
    input B2;
    input C1;
    input C2;
    output ZN;
    assign ZN = ~((B1 & B2) | (C1 & C2) | A);
endmodule

module AOI221_X4 (A, B1, B2, C1, C2, ZN);
    input A;
    input B1;
    input B2;
    input C1;
    input C2;
    output ZN;
    assign ZN = ~((B1 & B2) | (C1 & C2) | A);
endmodule

module AOI222_X1 (A1, A2, B1, B2, C1, C2, ZN);
    input A1;
    input A2;
    input B1;
    input B2;
    input C1;
    input C2;
    output ZN;
    assign ZN = ~((A1 & A2) | (B1 & B2) | (C1 & C2));
endmodule

module AOI222_X2 (A1, A2, B1, B2, C1, C2, ZN);
    input A1;
    input A2;
    input B1;
    input B2;
    input C1;
    input C2;
    output ZN;
    assign ZN = ~((A1 & A2) | (B1 & B2) | (C1 & C2));
endmodule

module AOI222_X4 (A1, A2, B1, B2, C1, C2, ZN);
    input A1;
    input A2;
    input B1;
    input B2;
    input C1;
    input C2;
    output ZN;
    assign ZN = ~((A1 & A2) | (B1 & B2) | (C1 & C2));
endmodule

module OAI21_X1 (A, B1, B2, ZN);
    input A;
    input B1;
    input B2;
    output ZN;
    assign ZN = ~((B1 | B2) & A);
endmodule

module OAI21_X2 (A, B1, B2, ZN);
    input A;
    input B1;
    input B2;
    output ZN;
    assign ZN = ~((B1 | B2) & A);
endmodule

module OAI21_X4 (A, B1, B2, ZN);
    input A;
    input B1;
    input B2;
    output ZN;
    assign ZN = ~((B1 | B2) & A);
endmodule

module OAI22_X1 (A1, A2, B1, B2, ZN);
    input A1;
    input A2;
    input B1;
    input B2;
    output ZN;
    assign ZN = ~((A1 | A2) & (B1 | B2));
endmodule

module OAI22_X2 (A1, A2, B1, B2, ZN);
    input A1;
    input A2;
    input B1;
    input B2;
    output ZN;
    assign ZN = ~((A1 | A2) & (B1 | B2));
endmodule

module OAI22_X4 (A1, A2, B1, B2, ZN);
    input A1;
    input A2;
    input B1;
    input B2;
    output ZN;
    assign ZN = ~((A1 | A2) & (B1 | B2));
endmodule

module OAI211_X1 (A, B, C1, C2, ZN);
    input A;
    input B;
    input C1;
    input C2;
    output ZN;
    assign ZN = ~((C1 | C2) & A & B);
endmodule

module OAI211_X2 (A, B, C1, C2, ZN);
    input A;
    input B;
    input C1;
    input C2;
    output ZN;
    assign ZN = ~((C1 | C2) & A & B);
endmodule

module OAI211_X4 (A, B, C1, C2, ZN);
    input A;
    input B;
    input C1;
    input C2;
    output ZN;
    assign ZN = ~((C1 | C2) & A & B);
endmodule

module OAI221_X1 (A, B1, B2, C1, C2, ZN);
    input A;
    input B1;
    input B2;
    input C1;
    input C2;
    output ZN;
    assign ZN = ~((B1 | B2) & (C1 | C2) & A);
endmodule

module OAI221_X2 (A, B1, B2, C1, C2, ZN);
    input A;
    input B1;
    input B2;
    input C1;
    input C2;
    output ZN;
    assign ZN = ~((B1 | B2) & (C1 | C2) & A);
endmodule

module OAI221_X4 (A, B1, B2, C1, C2, ZN);
    input A;
    input B1;
    input B2;
    input C1;
    input C2;
    output ZN;
    assign ZN = ~((B1 | B2) & (C1 | C2) & A);
endmodule

module OAI222_X1 (A1, A2, B1, B2, C1, C2, ZN);
    input A1;
    input A2;
    input B1;
    input B2;
    input C1;
    input C2;
    output ZN;
    assign ZN = ~((A1 | A2) & (B1 | B2) & (C1 | C2));
endmodule

module OAI222_X2 (A1, A2, B1, B2, C1, C2, ZN);
    input A1;
    input A2;
    input B1;
    input B2;
    input C1;
    input C2;
    output ZN;
    assign ZN = ~((A1 | A2) & (B1 | B2) & (C1 | C2));
endmodule

module OAI222_X4 (A1, A2, B1, B2, C1, C2, ZN);
    input A1;
    input A2;
    input B1;
    input B2;
    input C1;
    input C2;
    output ZN;
    assign ZN = ~((A1 | A2) & (B1 | B2) & (C1 | C2));
endmodule

module MUX2_X1 (A, B, S, Z);
    input A;
    input B;
    input S;
    output Z;
    assign Z = S ? B : A;
endmodule

module MUX2_X2 (A, B, S, Z);
    input A;
    input B;
    input S;
    output Z;
    assign Z = S ? B : A;
endmodule

module MUX2_X4 (A, B, S, Z);
    input A;
    input B;
    input S;
    output Z;
    assign Z = S ? B : A;
endmodule

module XNOR2_X1 (A, B, ZN);
    input A;
    input B;
    output ZN;
    assign ZN = ~(A ^ B);
endmodule

module XNOR2_X2 (A, B, ZN);
    input A;
    input B;
    output ZN;
    assign ZN = ~(A ^ B);
endmodule

module XNOR2_X4 (A, B, ZN);
    input A;
    input B;
    output ZN;
    assign ZN = ~(A ^ B);
endmodule

module XOR2_X1 (A, B, Z);
    input A;
    input B;
    output Z;
    assign Z = A ^ B;
endmodule

module XOR2_X2 (A, B, Z);
    input A;
    input B;
    output Z;
    assign Z = A ^ B;
endmodule

module XOR2_X4 (A, B, Z);
    input A;
    input B;
    output Z;
    assign Z = A ^ B;
endmodule

module LOGIC0_X1 (Z);
    output Z;
    assign Z = 1'b0;
endmodule

module LOGIC1_X1 (Z);
    output Z;
    assign Z = 1'b1;
endmodule

module LOGIC0_X2 (Z);
    output Z;
    assign Z = 1'b0;
endmodule

module LOGIC1_X2 (Z);
    output Z;
    assign Z = 1'b1;
endmodule

module LOGIC0_X4 (Z);
    output Z;
    assign Z = 1'b0;
endmodule

module LOGIC1_X4 (Z);
    output Z;
    assign Z = 1'b1;
endmodule

module DFF_X1 (D, CK, Q, QN);
    input D, CK;
    output reg Q;
    output QN;
    assign QN = ~Q;
    always @(posedge CK) Q <= D;
endmodule

module DFF_X2 (D, CK, Q, QN);
    input D, CK;
    output reg Q;
    output QN;
    assign QN = ~Q;
    always @(posedge CK) Q <= D;
endmodule

module DFF_X4 (D, CK, Q, QN);
    input D, CK;
    output reg Q;
    output QN;
    assign QN = ~Q;
    always @(posedge CK) Q <= D;
endmodule

module DFFR_X1 (D, CK, RN, Q, QN);
    input D, CK, RN;
    output reg Q;
    output QN;
    assign QN = ~Q;
    always @(posedge CK or negedge RN)
        if (!RN) Q <= 1'b0;
        else     Q <= D;
endmodule

module DFFR_X2 (D, CK, RN, Q, QN);
    input D, CK, RN;
    output reg Q;
    output QN;
    assign QN = ~Q;
    always @(posedge CK or negedge RN)
        if (!RN) Q <= 1'b0;
        else     Q <= D;
endmodule

module DFFR_X4 (D, CK, RN, Q, QN);
    input D, CK, RN;
    output reg Q;
    output QN;
    assign QN = ~Q;
    always @(posedge CK or negedge RN)
        if (!RN) Q <= 1'b0;
        else     Q <= D;
endmodule

module DFFS_X1 (D, CK, SN, Q, QN);
    input D, CK, SN;
    output reg Q;
    output QN;
    assign QN = ~Q;
    always @(posedge CK or negedge SN)
        if (!SN) Q <= 1'b1;
        else     Q <= D;
endmodule

module DFFS_X2 (D, CK, SN, Q, QN);
    input D, CK, SN;
    output reg Q;
    output QN;
    assign QN = ~Q;
    always @(posedge CK or negedge SN)
        if (!SN) Q <= 1'b1;
        else     Q <= D;
endmodule

module DFFS_X4 (D, CK, SN, Q, QN);
    input D, CK, SN;
    output reg Q;
    output QN;
    assign QN = ~Q;
    always @(posedge CK or negedge SN)
        if (!SN) Q <= 1'b1;
        else     Q <= D;
endmodule

