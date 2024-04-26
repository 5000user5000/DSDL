`ifndef ADDERS
`define ADDERS
`include "gates.v"

// half adder, gate level modeling
module HA(output C, S, input A, B);
	XOR g0(S, A, B);
	AND g1(C, A, B);
endmodule

// full adder, gate level modeling
module FA(output CO, S, input A, B, CI);
	wire c0, s0, c1, s1;
	HA ha0(c0, s0, A, B);
	HA ha1(c1, s1, s0, CI);
	assign S = s1;
	OR or0(CO, c0, c1);
endmodule

// adder without delay, register-transfer level modeling
module adder_rtl(
	output C3,       // carry output
	output[2:0] S,   // sum
	input[2:0] A, B, // operands
	input C0         // carry input
	);
	assign {C3, S} = A+B+C0;
endmodule

//  ripple-carry adder, gate level modeling
//  Do not modify the input/output of module
module rca_gl(
	output C3,       // carry output
	output[2:0] S,   // sum
	input[2:0] A, B, // operands
	input C0         // carry input
	);

	// TODO:: Implement gate-level RCA
	wire[3:0] c;
	assign c[0] = C0;
	assign C3 = c[3];
	FA fa0(c[1], S[0], A[0], B[0], c[0]);
	FA fa1(c[2], S[1], A[1], B[1], c[1]);
	FA fa2(c[3], S[2], A[2], B[2], c[2]);
endmodule

// carry-lookahead adder, gate level modeling
// Do not modify the input/output of module
module cla_gl(
	output C3,       // carry output
	output[2:0] S,   // sum
	input[2:0] A, B, // operands
	input C0         // carry input
	);

	// TODO:: Implement gate-level CLA
	wire [2:0] G, P;
	// Generate and Propagate
	AND g0(G[0], A[0], B[0]); // Generate，G = A & B
	AND g1(G[1], A[1], B[1]);
	AND g2(G[2], A[2], B[2]);

	OR p0(P[0], A[0], B[0]); // Propagate，P = A | B，本是 xor，但 or 較快(gates.v)
	OR p1(P[1], A[1], B[1]);
	OR p2(P[2], A[2], B[2]);

	// Carry calculations
	wire [3:0] C;
	assign C[0] = C0;
	assign C3 = C[3];
	wire w11, w21, w22, w31, w32, w33;
	// c1
	AND c11(w11, G[0], P[0]);
	OR c1(C[1], G[0], w11);
	// c2
	AND c21(w21, G[0], P[1]);
	AND4 c22(w22, P[0], P[1], C[0],1);
	OR4 c2(C[2], G[1], w21, w22,0);
	// c3
	AND c31(w31, G[1], P[2]);
	AND4 c32(w32, P[1], P[2], G[0],1);
	AND4 c33(w33, P[0], P[1], P[2],C[0]);
	OR4 c3(C[3], G[2], w31, w32, w33);

	// Sum calculations
	wire [3:1] co;
	FA s0(co[1], S[0], A[0], B[0], C[0]);
	FA s1(co[2], S[1], A[1], B[1], C[1]);
	FA s2(co[3], S[2], A[2], B[2], C[2]);
		
endmodule

`endif
