`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:08:24 11/14/2020 
// Design Name: 
// Module Name:    EXT 
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
`define sign_ext 2'b00
`define zero_ext 2'b01
`define lui_ext 2'b10
module EXT(
	input [15:0] imm,
	input [1:0] EXTOp,
	output reg [31:0] EXTimm
    );
	
	always @(*) begin
		case(EXTOp)
			`sign_ext:	EXTimm = {{16{imm[15]}}, imm};
			`zero_ext:	EXTimm = {{16{1'b0}}, imm};
			`lui_ext:	EXTimm = {imm, {16{1'b0}}};
			default:		EXTimm = 32'h12345678;
		endcase
	end

endmodule
