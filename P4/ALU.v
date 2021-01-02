`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:57:37 11/14/2020 
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
`define ADD 2'b00
`define SUB 2'b01
`define OR 2'b10

module ALU(
	input [31:0] num1,
	input [31:0] num2,
	input [1:0] ALUOp,
	output reg [31:0] result,
	output zero
    );
	
	always @(*) begin
		case(ALUOp)
			`ADD:		result = num1 + num2;
			`SUB:		result = num1 - num2;
			`OR:		result = num1 | num2;
			default:	result = 32'h12345678;
		endcase
	end
	
	assign zero = (num1 == num2) ? 1'b1 : 1'b0;
	
endmodule
