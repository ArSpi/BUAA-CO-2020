`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:08:31 10/02/2020 
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
module ALU(inA,inB,op,ans);
	input wire [3:0] inA;
	input wire [3:0] inB;
	input wire [1:0] op;
	output wire [3:0] ans;
	
	assign ans = (op == 2'b00) ? inA & inB :
					 (op == 2'b01) ? inA | inB :
					 (op == 2'b10) ? inA ^ inB :
					 (op == 2'b11) ? inA + inB :
														4'b0000;

endmodule
