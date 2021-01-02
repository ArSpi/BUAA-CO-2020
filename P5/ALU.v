`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:28:10 11/29/2020 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
	input wire [31:0] Instr_E,
	input wire [31:0] A,
	input wire [31:0] B,
	output reg [31:0] ALUout
    );
	wire [3:0] ALUOp;
	Decoder code_ALU(.Instr(Instr_E), .ALUOp(ALUOp));
	
	always @(*) begin
		case(ALUOp)
			`ADD:ALUout = A + B;
			`SUB:ALUout = A - B;
			`OR:ALUout = A | B;
			default:ALUout = 32'b0;
		endcase
	end

endmodule
