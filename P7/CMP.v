`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:58:23 11/29/2020 
// Design Name: 
// Module Name:    CMP 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`default_nettype none
module CMP(
	input wire [31:0] Instr_D,
	input wire [31:0] real_RFRD1,
	input wire [31:0] real_RFRD2,
	output wire zero
    );
	wire [31:0] D1, D2;
	assign D1 = real_RFRD1;
	assign D2 = real_RFRD2;
	
	wire beq, bne, blez, bgtz, bltz, bgez;
	Decoder code_CMP(.Instr(Instr_D), .beq(beq), .bne(bne), .blez(blez), .bgtz(bgtz), .bltz(bltz), .bgez(bgez));
	
	assign zero = (beq && (D1 == D2))          ? 1'b1 :
	              (bne && (D1 != D2))          ? 1'b1 :
					  (blez && ($signed(D1) <= 0)) ? 1'b1 :
					  (bgtz && ($signed(D1) > 0))  ? 1'b1 :
					  (bltz && ($signed(D1) < 0))  ? 1'b1 :
					  (bgez && ($signed(D1) >= 0)) ? 1'b1 :
					                                 1'b0;

endmodule
