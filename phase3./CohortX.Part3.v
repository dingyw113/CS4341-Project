`timescale 1ns/1ns

//=============================================
//
// Half Adder
//
//=============================================
module HalfAdder(
	input A, B, 
	output carry, sum
);

	assign sum = A ^ B;
	assign carry = A & B;

endmodule

//=============================================
//
// Full Adder
//
//=============================================
module FullAdder(
	input A, B, C,
	output carry, sum
	);

	wire c0;
	wire s0;
	wire c1;
	wire s1;

	HalfAdder ha1(A, B, c0, s0);
	HalfAdder ha2(s0, C, c1, s1);
	
	assign sum = s1;
	//assign sum = A ^ B ^ C;
	assign carry = c1 | c0;
	//assign carry = (A ^ B) & C) | (A & B);
	
endmodule

//=================================================================
//
// 16-bit Full Adder-Subtractor
//
//=================================================================
module addsub(
	input [15:0] inputA, inputB,
	input mode,
	output [31:0] outputC,
	output error
);

	wire [31:0] sum;
	wire b[15:0]; // XOR Interfaces in an array of 1-bit wires
	wire c[16:0]; // Carry Interfaces

	assign c[0] = mode;
	assign b[0] = inputB[0] ^ mode;
	assign b[1] = inputB[1] ^ mode;
	assign b[2] = inputB[2] ^ mode;
	assign b[3] = inputB[3] ^ mode;
	assign b[4] = inputB[4] ^ mode;
	assign b[5] = inputB[5] ^ mode;
	assign b[6] = inputB[6] ^ mode;
	assign b[7] = inputB[7] ^ mode;
	assign b[8] = inputB[8] ^ mode;
	assign b[9] = inputB[9] ^ mode;
	assign b[10] = inputB[10] ^ mode;
	assign b[11] = inputB[11] ^ mode;
	assign b[12] = inputB[12] ^ mode;
	assign b[13] = inputB[13] ^ mode;
	assign b[14] = inputB[14] ^ mode;
	assign b[15] = inputB[15] ^ mode;

	FullAdder fa0(inputA[0], b[0], c[0], c[1], sum[0]);
	FullAdder fa1(inputA[1], b[1], c[1], c[2], sum[1]);
	FullAdder fa2(inputA[2], b[2], c[2], c[3], sum[2]);
	FullAdder fa3(inputA[3], b[3], c[3], c[4], sum[3]);
	FullAdder fa4(inputA[4], b[4], c[4], c[5], sum[4]);
	FullAdder fa5(inputA[5], b[5], c[5], c[6], sum[5]);
	FullAdder fa6(inputA[6], b[6], c[6], c[7], sum[6]);
	FullAdder fa7(inputA[7], b[7], c[7], c[8], sum[7]);
	FullAdder fa8(inputA[8], b[8], c[8], c[9], sum[8]);
	FullAdder fa9(inputA[9], b[9], c[9], c[10], sum[9]);
	FullAdder fa10(inputA[10], b[10], c[10], c[11], sum[10]);
	FullAdder fa11(inputA[11], b[11], c[11], c[12], sum[11]);
	FullAdder fa12(inputA[12], b[12], c[12], c[13], sum[12]);
	FullAdder fa13(inputA[13], b[13], c[13], c[14], sum[13]);
	FullAdder fa14(inputA[14], b[14], c[14], c[15], sum[14]);
	FullAdder fa15(inputA[15], b[15], c[15], c[16], sum[15]);

	assign sum[16] = c[16] ^ mode;

	// Output is a 32-bit value, extend the proper signed bit while also adding carry bit
	wire extend;
	assign extend = sum[15] & mode;
	assign outputC = {{15{extend}}, sum[16:0]}; // Replicate the value in 'extend' 15 times and concatenate it with the lower 17 bits of sum

	assign error = c[15] ^ c[16];

endmodule

//=================================================================
//
// 16-bit Full Adder for use in 16-bit Multiplier
//
//=================================================================
module SixteenBitFullAdder(
	input [15:0] A, B,
	input C,
	output [15:0] carry, sum
);

	FullAdder fa0(A[0], B[0], C, carry[0], sum[0]);
	FullAdder fa1(A[1], B[1], carry[0], carry[1], sum[1]);
	FullAdder fa2(A[2], B[2], carry[1], carry[2], sum[2]);
	FullAdder fa3(A[3], B[3], carry[2], carry[3], sum[3]);
	FullAdder fa4(A[4], B[4], carry[3], carry[4], sum[4]);
	FullAdder fa5(A[5], B[5], carry[4], carry[5], sum[5]);
	FullAdder fa6(A[6], B[6], carry[5], carry[6], sum[6]);
	FullAdder fa7(A[7], B[7], carry[6], carry[7], sum[7]);
	FullAdder fa8(A[8], B[8], carry[7], carry[8], sum[8]);
	FullAdder fa9(A[9], B[9], carry[8], carry[9], sum[9]);
	FullAdder fa10(A[10], B[10], carry[9], carry[10], sum[10]);
	FullAdder fa11(A[11], B[11], carry[10], carry[11], sum[11]);
	FullAdder fa12(A[12], B[12], carry[11], carry[12], sum[12]);
	FullAdder fa13(A[13], B[13], carry[12], carry[13], sum[13]);
	FullAdder fa14(A[14], B[14], carry[13], carry[14], sum[14]);
	FullAdder fa15(A[15], B[15], carry[14], carry[15], sum[15]);

endmodule

//=================================================================
//
// 16-bit Multiplier
//
//=================================================================
module mul(
	input [15:0] A, B,
	output [31:0] C
);

	// Local variables: Arrays of length 16 with each value being a 16-bit bus
	// Syntax: [bus dimensions] <var name> [array dimensions]
	// Bit access syntax: <var name> [array index] [bus bit index]
	wire [15:0] augend [15:0];
	wire [15:0] addend [15:0];
	wire [15:0] sum [15:0];
	wire [15:0] carry [15:0];

	SixteenBitFullAdder add0(augend[0], addend[0], 1'b0, carry[0], sum[0]);
	SixteenBitFullAdder add1(augend[1], addend[1], 1'b0, carry[1], sum[1]);
	SixteenBitFullAdder add2(augend[2], addend[2], 1'b0, carry[2], sum[2]);
	SixteenBitFullAdder add3(augend[3], addend[3], 1'b0, carry[3], sum[3]);
	SixteenBitFullAdder add4(augend[4], addend[4], 1'b0, carry[4], sum[4]);
	SixteenBitFullAdder add5(augend[5], addend[5], 1'b0, carry[5], sum[5]);
	SixteenBitFullAdder add6(augend[6], addend[6], 1'b0, carry[6], sum[6]);
	SixteenBitFullAdder add7(augend[7], addend[7], 1'b0, carry[7], sum[7]);
	SixteenBitFullAdder add8(augend[8], addend[8], 1'b0, carry[8], sum[8]);
	SixteenBitFullAdder add9(augend[9], addend[9], 1'b0, carry[9], sum[9]);
	SixteenBitFullAdder add10(augend[10], addend[10], 1'b0, carry[10], sum[10]);
	SixteenBitFullAdder add11(augend[11], addend[11], 1'b0, carry[11], sum[11]);
	SixteenBitFullAdder add12(augend[12], addend[12], 1'b0, carry[12], sum[12]);
	SixteenBitFullAdder add13(augend[13], addend[13], 1'b0, carry[13], sum[13]);
	SixteenBitFullAdder add14(augend[14], addend[14], 1'b0, carry[14], sum[14]);
	SixteenBitFullAdder add15(augend[15], addend[15], 1'b0, carry[15], sum[15]);

	assign augend[0] = {1'b0, A[0]&B[15], A[0]&B[14], A[0]&B[13], A[0]&B[12], A[0]&B[11], A[0]&B[10], A[0]&B[9], A[0]&B[8], A[0]&B[7], A[0]&B[6], A[0]&B[5], A[0]&B[4], A[0]&B[3], A[0]&B[2], A[0]&B[1]};
	assign addend[0] = {A[1]&B[15], A[1]&B[14], A[1]&B[13], A[1]&B[12], A[1]&B[11], A[1]&B[10], A[1]&B[9], A[1]&B[8], A[1]&B[7], A[1]&B[6], A[1]&B[5], A[1]&B[4], A[1]&B[3], A[1]&B[2], A[1]&B[1], A[1]&B[0]};
	assign augend[1] = {carry[0][15], sum[0][15], sum[0][14], sum[0][13], sum[0][12], sum[0][11], sum[0][10], sum[0][9], sum[0][8], sum[0][7], sum[0][6], sum[0][5], sum[0][4], sum[0][3], sum[0][2], sum[0][1]};
	assign addend[1] = {A[2]&B[15], A[2]&B[14], A[2]&B[13], A[2]&B[12], A[2]&B[11], A[2]&B[10], A[2]&B[9], A[2]&B[8], A[2]&B[7], A[2]&B[6], A[2]&B[5], A[2]&B[4], A[2]&B[3], A[2]&B[2], A[2]&B[1], A[2]&B[0]};
	assign augend[2] = {carry[1][15], sum[1][15], sum[1][14], sum[1][13], sum[1][12], sum[1][11], sum[1][10], sum[1][9], sum[1][8], sum[1][7], sum[1][6], sum[1][5], sum[1][4], sum[1][3], sum[1][2], sum[1][1]};
	assign addend[2] = {A[3]&B[15], A[3]&B[14], A[3]&B[13], A[3]&B[12], A[3]&B[11], A[3]&B[10], A[3]&B[9], A[3]&B[8], A[3]&B[7], A[3]&B[6], A[3]&B[5], A[3]&B[4], A[3]&B[3], A[3]&B[2], A[3]&B[1], A[3]&B[0]};
	assign augend[3] = {carry[2][15], sum[2][15], sum[2][14], sum[2][13], sum[2][12], sum[2][11], sum[2][10], sum[2][9], sum[2][8], sum[2][7], sum[2][6], sum[2][5], sum[2][4], sum[2][3], sum[2][2], sum[2][1]};
	assign addend[3] = {A[4]&B[15], A[4]&B[14], A[4]&B[13], A[4]&B[12], A[4]&B[11], A[4]&B[10], A[4]&B[9], A[4]&B[8], A[4]&B[7], A[4]&B[6], A[4]&B[5], A[4]&B[4], A[4]&B[3], A[4]&B[2], A[4]&B[1], A[4]&B[0]};
	assign augend[4] = {carry[3][15], sum[3][15], sum[3][14], sum[3][13], sum[3][12], sum[3][11], sum[3][10], sum[3][9], sum[3][8], sum[3][7], sum[3][6], sum[3][5], sum[3][4], sum[3][3], sum[3][2], sum[3][1]};
	assign addend[4] = {A[5]&B[15], A[5]&B[14], A[5]&B[13], A[5]&B[12], A[5]&B[11], A[5]&B[10], A[5]&B[9], A[5]&B[8], A[5]&B[7], A[5]&B[6], A[5]&B[5], A[5]&B[4], A[5]&B[3], A[5]&B[2], A[5]&B[1], A[5]&B[0]};
	assign augend[5] = {carry[4][15], sum[4][15], sum[4][14], sum[4][13], sum[4][12], sum[4][11], sum[4][10], sum[4][9], sum[4][8], sum[4][7], sum[4][6], sum[4][5], sum[4][4], sum[4][3], sum[4][2], sum[4][1]};
	assign addend[5] = {A[6]&B[15], A[6]&B[14], A[6]&B[13], A[6]&B[12], A[6]&B[11], A[6]&B[10], A[6]&B[9], A[6]&B[8], A[6]&B[7], A[6]&B[6], A[6]&B[5], A[6]&B[4], A[6]&B[3], A[6]&B[2], A[6]&B[1], A[6]&B[0]};
	assign augend[6] = {carry[5][15], sum[5][15], sum[5][14], sum[5][13], sum[5][12], sum[5][11], sum[5][10], sum[5][9], sum[5][8], sum[5][7], sum[5][6], sum[5][5], sum[5][4], sum[5][3], sum[5][2], sum[5][1]};
	assign addend[6] = {A[7]&B[15], A[7]&B[14], A[7]&B[13], A[7]&B[12], A[7]&B[11], A[7]&B[10], A[7]&B[9], A[7]&B[8], A[7]&B[7], A[7]&B[6], A[7]&B[5], A[7]&B[4], A[7]&B[3], A[7]&B[2], A[7]&B[1], A[7]&B[0]};
	assign augend[7] = {carry[6][15], sum[6][15], sum[6][14], sum[6][13], sum[6][12], sum[6][11], sum[6][10], sum[6][9], sum[6][8], sum[6][7], sum[6][6], sum[6][5], sum[6][4], sum[6][3], sum[6][2], sum[6][1]};
	assign addend[7] = {A[8]&B[15], A[8]&B[14], A[8]&B[13], A[8]&B[12], A[8]&B[11], A[8]&B[10], A[8]&B[9], A[8]&B[8], A[8]&B[7], A[8]&B[6], A[8]&B[5], A[8]&B[4], A[8]&B[3], A[8]&B[2], A[8]&B[1], A[8]&B[0]};
	assign augend[8] = {carry[7][15], sum[7][15], sum[7][14], sum[7][13], sum[7][12], sum[7][11], sum[7][10], sum[7][9], sum[7][8], sum[7][7], sum[7][6], sum[7][5], sum[7][4], sum[7][3], sum[7][2], sum[7][1]};
	assign addend[8] = {A[9]&B[15], A[9]&B[14], A[9]&B[13], A[9]&B[12], A[9]&B[11], A[9]&B[10], A[9]&B[9], A[9]&B[8], A[9]&B[7], A[9]&B[6], A[9]&B[5], A[9]&B[4], A[9]&B[3], A[9]&B[2], A[9]&B[1], A[9]&B[0]};
	assign augend[9] = {carry[8][15], sum[8][15], sum[8][14], sum[8][13], sum[8][12], sum[8][11], sum[8][10], sum[8][9], sum[8][8], sum[8][7], sum[8][6], sum[8][5], sum[8][4], sum[8][3], sum[8][2], sum[8][1]};
	assign addend[9] = {A[10]&B[15], A[10]&B[14], A[10]&B[13], A[10]&B[12], A[10]&B[11], A[10]&B[10], A[10]&B[9], A[10]&B[8], A[10]&B[7], A[10]&B[6], A[10]&B[5], A[10]&B[4], A[10]&B[3], A[10]&B[2], A[10]&B[1], A[10]&B[0]};
	assign augend[10] = {carry[9][15], sum[9][15], sum[9][14], sum[9][13], sum[9][12], sum[9][11], sum[9][10], sum[9][9], sum[9][8], sum[9][7], sum[9][6], sum[9][5], sum[9][4], sum[9][3], sum[9][2], sum[9][1]};
	assign addend[10] = {A[11]&B[15], A[11]&B[14], A[11]&B[13], A[11]&B[12], A[11]&B[11], A[11]&B[10], A[11]&B[9], A[11]&B[8], A[11]&B[7], A[11]&B[6], A[11]&B[5], A[11]&B[4], A[11]&B[3], A[11]&B[2], A[11]&B[1], A[11]&B[0]};
	assign augend[11] = {carry[10][15], sum[10][15], sum[10][14], sum[10][13], sum[10][12], sum[10][11], sum[10][10], sum[10][9], sum[10][8], sum[10][7], sum[10][6], sum[10][5], sum[10][4], sum[10][3], sum[10][2], sum[10][1]};
	assign addend[11] = {A[12]&B[15], A[12]&B[14], A[12]&B[13], A[12]&B[12], A[12]&B[11], A[12]&B[10], A[12]&B[9], A[12]&B[8], A[12]&B[7], A[12]&B[6], A[12]&B[5], A[12]&B[4], A[12]&B[3], A[12]&B[2], A[12]&B[1], A[12]&B[0]};
	assign augend[12] = {carry[11][15], sum[11][15], sum[11][14], sum[11][13], sum[11][12], sum[11][11], sum[11][10], sum[11][9], sum[11][8], sum[11][7], sum[11][6], sum[11][5], sum[11][4], sum[11][3], sum[11][2], sum[11][1]};
	assign addend[12] = {A[13]&B[15], A[13]&B[14], A[13]&B[13], A[13]&B[12], A[13]&B[11], A[13]&B[10], A[13]&B[9], A[13]&B[8], A[13]&B[7], A[13]&B[6], A[13]&B[5], A[13]&B[4], A[13]&B[3], A[13]&B[2], A[13]&B[1], A[13]&B[0]};
	assign augend[13] = {carry[12][15], sum[12][15], sum[12][14], sum[12][13], sum[12][12], sum[12][11], sum[12][10], sum[12][9], sum[12][8], sum[12][7], sum[12][6], sum[12][5], sum[12][4], sum[12][3], sum[12][2], sum[12][1]};
	assign addend[13] = {A[14]&B[15], A[14]&B[14], A[14]&B[13], A[14]&B[12], A[14]&B[11], A[14]&B[10], A[14]&B[9], A[14]&B[8], A[14]&B[7], A[14]&B[6], A[14]&B[5], A[14]&B[4], A[14]&B[3], A[14]&B[2], A[14]&B[1], A[14]&B[0]};
	assign augend[14] = {carry[13][15], sum[13][15], sum[13][14], sum[13][13], sum[13][12], sum[13][11], sum[13][10], sum[13][9], sum[13][8], sum[13][7], sum[13][6], sum[13][5], sum[13][4], sum[13][3], sum[13][2], sum[13][1]};
	assign addend[14] = {A[15]&B[15], A[15]&B[14], A[15]&B[13], A[15]&B[12], A[15]&B[11], A[15]&B[10], A[15]&B[9], A[15]&B[8], A[15]&B[7], A[15]&B[6], A[15]&B[5], A[15]&B[4], A[15]&B[3], A[15]&B[2], A[15]&B[1], A[15]&B[0]};

	assign C[0] = A[0]&B[0];
	assign C[1] = sum[0][0];
	assign C[2] = sum[1][0];
	assign C[3] = sum[2][0];
	assign C[4] = sum[3][0];
	assign C[5] = sum[4][0];
	assign C[6] = sum[5][0];
	assign C[7] = sum[6][0];
	assign C[8] = sum[7][0];
	assign C[9] = sum[8][0];
	assign C[10] = sum[9][0];
	assign C[11] = sum[10][0];
	assign C[12] = sum[11][0];
	assign C[13] = sum[12][0];
	assign C[14] = sum[13][0];
	assign C[15] = sum[14][0];

	assign C[16] = sum[14][1];
	assign C[17] = sum[14][2];
	assign C[18] = sum[14][3];
	assign C[19] = sum[14][4];
	assign C[20] = sum[14][5];
	assign C[21] = sum[14][6];
	assign C[22] = sum[14][7];
	assign C[23] = sum[14][8];
	assign C[24] = sum[14][9];
	assign C[25] = sum[14][10];
	assign C[26] = sum[14][11];
	assign C[27] = sum[14][12];
	assign C[28] = sum[14][13];
	assign C[29] = sum[14][14];
	assign C[30] = sum[14][15];
	assign C[31] = carry[14][15];

endmodule

//=================================================================
//
// Division
//
//=================================================================
module div(
	input [15:0] inputA, inputB,
	output reg [31:0] outputC,
	output reg error
);

	always @ (*) begin
		if(inputB[15:0] == 0) begin
			outputC = 32'dx;
			error = 1;
		end
		else begin
			outputC = inputA / inputB;
			error = 0;
		end
	end

endmodule

//=================================================================
//
// Modulo
//
//=================================================================
module mod(
	input [15:0] inputA, inputB,
	output reg [31:0] outputC,
	output reg error
);

	always @ (*) begin
		if(inputB[15:0] == 0) begin
			outputC = 32'dx;
			error = 1;
		end
		else begin
			outputC = inputA % inputB;
			error = 0;
		end
	end

endmodule

//=================================================================
//
// Logical Operations
//
//=================================================================
module AND(
	input [15:0] inputA, inputB,
	output [31:0] outputC
);
	assign outputC = {{16'b0}, inputA & inputB};
endmodule

module NAND(
	input [15:0] inputA, inputB,
	output [31:0] outputC
);
	assign outputC = {{16'b0}, ~(inputA & inputB)};
endmodule

module NOR(
	input [15:0] inputA, inputB,
	output [31:0] outputC
);
	assign outputC = {{16'b0}, ~(inputA | inputB)};
endmodule

module NOT(
	input [15:0] inputA,
	output [31:0] outputC
);
	assign outputC = {{16'b0}, ~inputA};
endmodule

module OR(
	input [15:0] inputA, inputB,
	output [31:0] outputC
);
	assign outputC = {{16'b0}, inputA | inputB};
endmodule

module XNOR(
	input [15:0] inputA, inputB,
	output [31:0] outputC
);
	assign outputC = {{16'b0}, ~(inputA ^ inputB)};
endmodule

module XOR(
	input [15:0] inputA, inputB,
	output [31:0] outputC
);
	assign outputC = {{16'b0}, inputA ^ inputB};
endmodule

//=================================================================
//
// Decoder: 4-bit opcode to 16-channel output
//
//=================================================================
module decoder(
	input [3:0] opcode,
	output [15:0] onehot
);
	
	assign onehot[ 0]=~opcode[3]&~opcode[2]&~opcode[1]&~opcode[0]; // 0000
	assign onehot[ 1]=~opcode[3]&~opcode[2]&~opcode[1]& opcode[0]; // 0001
	assign onehot[ 2]=~opcode[3]&~opcode[2]& opcode[1]&~opcode[0]; // 0010
	assign onehot[ 3]=~opcode[3]&~opcode[2]& opcode[1]& opcode[0]; // ...
	assign onehot[ 4]=~opcode[3]& opcode[2]&~opcode[1]&~opcode[0];
	assign onehot[ 5]=~opcode[3]& opcode[2]&~opcode[1]& opcode[0];
	assign onehot[ 6]=~opcode[3]& opcode[2]& opcode[1]&~opcode[0];
	assign onehot[ 7]=~opcode[3]& opcode[2]& opcode[1]& opcode[0];
	assign onehot[ 8]= opcode[3]&~opcode[2]&~opcode[1]&~opcode[0];
	assign onehot[ 9]= opcode[3]&~opcode[2]&~opcode[1]& opcode[0];
	assign onehot[10]= opcode[3]&~opcode[2]& opcode[1]&~opcode[0];
	assign onehot[11]= opcode[3]&~opcode[2]& opcode[1]& opcode[0];
	assign onehot[12]= opcode[3]& opcode[2]&~opcode[1]&~opcode[0]; // ...
	assign onehot[13]= opcode[3]& opcode[2]&~opcode[1]& opcode[0]; // 1101
	assign onehot[14]= opcode[3]& opcode[2]& opcode[1]&~opcode[0]; // 1110
	assign onehot[15]= opcode[3]& opcode[2]& opcode[1]& opcode[0]; // 1111
	
endmodule

//=================================================================
//
// Multiplexor
//
//=================================================================
module mux(
	input [15:0][31:0] channels,
	input [15:0] select,
	output [31:0] outputC
);

	assign outputC = 	({32{select[15]}} & channels[15]) | 
						({32{select[14]}} & channels[14]) | // XOR
						({32{select[13]}} & channels[13]) | // XNOR
						({32{select[12]}} & channels[12]) | // OR
						({32{select[11]}} & channels[11]) | // NOT
						({32{select[10]}} & channels[10]) | // NOR
						({32{select[ 9]}} & channels[ 9]) | // NAND
						({32{select[ 8]}} & channels[ 8]) | // AND
						({32{select[ 7]}} & channels[ 7]) | // MODULUS
						({32{select[ 6]}} & channels[ 6]) | // DIVIDE
						({32{select[ 5]}} & channels[ 5]) | // MULTIPLY
						({32{select[ 4]}} & channels[ 4]) | // SUBTRACT
						({32{select[ 3]}} & channels[ 3]) | // ADD
						({32{select[ 2]}} & channels[ 2]) | // Preset channel (all 1s)
						({32{select[ 1]}} & channels[ 1]) | // Reset channel (all 0s)
						({32{select[ 0]}} & channels[ 0]);  // No-Op/Feedback channel (previous output)

endmodule

//=================================================================
//
// D Flip-Flop / Memory register
//
//=================================================================

module dff #(parameter width = 1) (
	input clk,
	input [width-1:0] in,
	output reg [width-1:0] out
);
	always @(posedge clk)
		out = in;
endmodule

//=================================================================
//
// Breadboard
//
//=================================================================
module breadboard(
	input [15:0] inputA, 
	input [3:0] opcode, 
	input clk,
	output [31:0] outputC,
	output [1:0] error
);

	wire [15:0] inputB = outputC[15:0]; // Is now an interface from the lower 16 bits of outputC to all other modules

	// Error codes
	wire overflow, divByZero, modByZero;
	assign error = {(select[6] && divByZero) | (select[7] && modByZero), select[3] & overflow};

	// Output interfaces that go from module output to multiplexor channel input
	wire [31:0] outputADD, outputSUB, outputMUL, outputDIV, outputMOD, outputMUX, outputAND, outputNAND, outputNOR, outputNOT, outputOR, outputXNOR, outputXOR;
	wire dummy; // Subtraction "error code" that will be plugged into the module but not used

	addsub addy(inputB, inputA, 1'b0, outputADD, overflow);
	addsub suby(inputB, inputA, 1'b1, outputSUB, dummy);
	mul muly(inputB, inputA, outputMUL);
	div divy(inputB, inputA, outputDIV, divByZero);
	mod mody(inputB, inputA, outputMOD, modByZero);
	AND andy(inputB, inputA, outputAND);
	NAND nandy(inputB, inputA, outputNAND);
	NOR nory(inputB, inputA, outputNOR);
	NOT noty(inputB, outputNOT);
	OR ory(inputB, inputA, outputOR);
	XNOR xnory(inputB, inputA, outputXNOR);
	XOR xory(inputB, inputA, outputXOR);

	wire [15:0][31:0] channels; // 2D bus with 16 32-bit values
	wire [15:0] select; // One-hot select output from decoder

	decoder decy(opcode, select);
	mux muxy(channels, select, outputMUX);
	
	wire [31:0] unknown; // Channels with no linked module output will have this "value"
	assign channels[ 0]=outputC;
	assign channels[ 1]=32'b0;
	assign channels[ 2]={32{1'b1}};
	assign channels[ 3]=outputADD;
	assign channels[ 4]=outputSUB;
	assign channels[ 5]=outputMUL;
	assign channels[ 6]=outputDIV;
	assign channels[ 7]=outputMOD;
	assign channels[ 8]=outputAND;
	assign channels[ 9]=outputNAND;
	assign channels[10]=outputNOR;
	assign channels[11]=outputNOT;
	assign channels[12]=outputOR;
	assign channels[13]=outputXNOR;
	assign channels[14]=outputXOR;
	assign channels[15]=unknown;

	dff #(32) memory(clk, outputMUX, outputC);

endmodule


//=================================================================
//
// Testbench
//
//=================================================================
module testbench();
    
	// Local variables
	reg [15:0] inputA, prevInputB;
	reg [3:0] opcode;
	reg clk = 1;
	wire [31:0] outputC;
	wire [1:0] error;

	breadboard bready(inputA, opcode, clk, outputC, error);

	always begin // Clock setup
		clk = ~clk;
		#10;
	end

	initial begin
		/*  Commands to view visualization with gtkwave:
			iverilog -o phase3.out phase3.v
			vvp phase3.out
			gtkwave phase3.vcd
		*/
		$dumpfile("phase3.vcd");
		$dumpvars(0, testbench);
	end

	// Stimulus
	initial begin

		#2;

		// Reset
		prevInputB = outputC[15:0];
		opcode = 4'd1;
		inputA = 32'd0;

		#10;
		$display("Input: %0d [%b] Feedback: %0d [%b] Opcode: RESET [%b] Output: %0d [%b] [%b] Error: [%b]", inputA, inputA, prevInputB, prevInputB, opcode, outputC, outputC[31:16], outputC[15:0], error);

		prevInputB = outputC[15:0];
		#10;

		// No-Op
		opcode = 4'd0;
		inputA = 32'd0;

		#10;
		$display("Input: %0d [%b] Feedback: %0d [%b] Opcode: NO-OP [%b] Output: %0d [%b] [%b] Error: [%b]", inputA, inputA, prevInputB, prevInputB, opcode, outputC, outputC[31:16], outputC[15:0], error);

		prevInputB = outputC[15:0];
		#10;

		// Add
		opcode = 4'd3;
		inputA = 32'd7;

		#10;
		$display("Input: %0d [%b] Feedback: %0d [%b] Opcode: ADD [%b] Output: %0d [%b] [%b] Error: [%b]", inputA, inputA, prevInputB, prevInputB, opcode, outputC, outputC[31:16], outputC[15:0], error);

		prevInputB = outputC[15:0];
		#10;

		// Sub
		opcode = 4'd4;
		inputA = 32'd3;

		#10;
		$display("Input: %0d [%b] Feedback: %0d [%b] Opcode: SUB [%b] Output: %0d [%b] [%b] Error: [%b]", inputA, inputA, prevInputB, prevInputB, opcode, outputC, outputC[31:16], outputC[15:0], error);

		prevInputB = outputC[15:0];
		#10;

		// Mul
		opcode = 4'd5;
		inputA = 32'd250;

		#10;
		$display("Input: %0d [%b] Feedback: %0d [%b] Opcode: MUL [%b] Output: %0d [%b] [%b] Error: [%b]", inputA, inputA, prevInputB, prevInputB, opcode, outputC, outputC[31:16], outputC[15:0], error);

		prevInputB = outputC[15:0];
		#10;

		// Div
		opcode = 4'd6;
		inputA = 32'd32;

		#10;
		$display("Input: %0d [%b] Feedback: %0d [%b] Opcode: DIV [%b] Output: %0d [%b] [%b] Error: [%b]", inputA, inputA, prevInputB, prevInputB, opcode, outputC, outputC[31:16], outputC[15:0], error);

		prevInputB = outputC[15:0];
		#10;
		
		// Mod
		opcode = 4'd7;
		inputA = 32'd4;

		#10;
		$display("Input: %0d [%b] Feedback: %0d [%b] Opcode: MOD [%b] Output: %0d [%b] [%b] Error: [%b]", inputA, inputA, prevInputB, prevInputB, opcode, outputC, outputC[31:16], outputC[15:0], error);

		prevInputB = outputC[15:0];
		#10;
		
		// And
		opcode = 4'd8;
		inputA = 32'd32;

		#10;
		$display("Input: %0d [%b] Feedback: %0d [%b] Opcode: AND [%b] Output: %0d [%b] [%b] Error: [%b]", inputA, inputA, prevInputB, prevInputB, opcode, outputC, outputC[31:16], outputC[15:0], error);

		prevInputB = outputC[15:0];
		#10;
		
		// Or
		opcode = 4'd12;
		inputA = 32'd42;

		#10;
		$display("Input: %0d [%b] Feedback: %0d [%b] Opcode: OR [%b] Output: %0d [%b] [%b] Error: [%b]", inputA, inputA, prevInputB, prevInputB, opcode, outputC, outputC[31:16], outputC[15:0], error);

		prevInputB = outputC[15:0];
		#10;
		
		// Not
		opcode = 4'd11;
		inputA = 32'd0;

		#10;
		$display("Input: %0d [%b] Feedback: %0d [%b] Opcode: NOT [%b] Output: %0d [%b] [%b] Error: [%b]", inputA, inputA, prevInputB, prevInputB, opcode, outputC, outputC[31:16], outputC[15:0], error);

		prevInputB = outputC[15:0];
		#10;
		
		// Xor
		opcode = 4'd14;
		inputA = 32'd65535;

		#10;
		$display("Input: %0d [%b] Feedback: %0d [%b] Opcode: XOR [%b] Output: %0d [%b] [%b] Error: [%b]", inputA, inputA, prevInputB, prevInputB, opcode, outputC, outputC[31:16], outputC[15:0], error);

		prevInputB = outputC[15:0];
		#10;
		
		// Xnor
		opcode = 4'd13;
		inputA = 32'd65525;

		#10;
		$display("Input: %0d [%b] Feedback: %0d [%b] Opcode: XNOR [%b] Output: %0d [%b] [%b] Error: [%b]", inputA, inputA, prevInputB, prevInputB, opcode, outputC, outputC[31:16], outputC[15:0], error);

		prevInputB = outputC[15:0];
		#10;
		
		// Nand
		opcode = 4'd9;
		inputA = 32'd65535;

		#10;
		$display("Input: %0d [%b] Feedback: %0d [%b] Opcode: NAND [%b] Output: %0d [%b] [%b] Error: [%b]", inputA, inputA, prevInputB, prevInputB, opcode, outputC, outputC[31:16], outputC[15:0], error);

		prevInputB = outputC[15:0];
		#10;
		
		// Nor
		opcode = 4'd10;
		inputA = 32'd65535;

		#10;
		$display("Input: %0d [%b] Feedback: %0d [%b] Opcode: NOR [%b] Output: %0d [%b] [%b] Error: [%b]", inputA, inputA, prevInputB, prevInputB, opcode, outputC, outputC[31:16], outputC[15:0], error);

		prevInputB = outputC[15:0];
		#10;
		
		// Preset
		opcode = 4'd2;
		inputA = 32'd0;

		#10;
		$display("Input: %0d [%b] Feedback: %0d [%b] Opcode: PRESET [%b] Output: %0d [%b] [%b] Error: [%b]", inputA, inputA, prevInputB, prevInputB, opcode, outputC, outputC[31:16], outputC[15:0], error);

		$finish;

	end

endmodule

/* Multiply module multiplication table tester

reg [15:0] loopi;
reg [15:0] loopj;
reg [31:0] results [15:0] [15:0];

for (loopi=0;loopi<16;loopi+=1) begin
	for (loopj=0;loopj<16;loopj+=1) begin
		inputA=loopi;
		inputB=loopj;
		#10;
		results[loopi][loopj]=outputMUL;
		$write(" %3d",outputMUL);
	end
	$display(";");
end

*/