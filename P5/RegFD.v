`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:39:35 11/30/2020 
// Design Name: 
// Module Name:    RegFD 
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
module RegFD(
	input wire clk,
	input wire reset,
	input wire En_RegFD,
	input wire [31:0] Instr,
	input wire [31:0] PC,
	output reg [31:0] Instr_D,
	output reg [31:0] PC_D
    );
	always @(posedge clk) begin
		if (reset) begin
			Instr_D <= 32'h00000000;
			PC_D <= 32'h00003000;
		end
		else begin
			if (En_RegFD) begin
				Instr_D <= Instr;
				PC_D <= PC;
			end
		end
	end

endmodule
