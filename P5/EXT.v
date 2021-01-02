`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:10:29 11/29/2020 
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
`default_nettype none
`include "define.v"
module EXT(
	input wire [31:0] Instr_D,
	output reg [31:0] EXTimm
    );
	wire [3:0] EXTOp;
	Decoder code_EXT(.Instr(Instr_D), .EXTOp(EXTOp));
	
	wire [15:0] imm;
	assign imm = Instr_D[15:0];
	always @(*) begin
		case(EXTOp)
			`sign_ext:EXTimm = {{16{imm[15]}}, imm};
			`zero_ext:EXTimm = {{16{1'b0}}, imm};
			`high_ext:EXTimm = {imm, {16{1'b0}}};
			default:EXTimm = 32'b0;
		endcase
	end

endmodule
