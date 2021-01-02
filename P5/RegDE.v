`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:39:49 11/30/2020 
// Design Name: 
// Module Name:    RegDE 
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
module RegDE(
	input wire clk,
	input wire reset,
	input wire Clr_RegDE,
	input wire [31:0] Instr_D,
	input wire [31:0] PC_D,
	input wire [4:0] RFWA,
	input wire [31:0] real_RFRD1,
	input wire [31:0] real_RFRD2,
	input wire [31:0] EXTimm,
	output reg [31:0] Instr_E,
	output reg [31:0] PC_E,
	output reg [4:0] RFWA_E,
	output reg [31:0] RFRD1_E,
	output reg [31:0] RFRD2_E,
	output reg [31:0] EXTimm_E
    );
	always @(posedge clk) begin
		if (reset || Clr_RegDE) begin
			Instr_E <= 32'h00000000;
			PC_E <= 32'h00003000;
			RFWA_E <= 5'b00000;
			RFRD1_E <= 32'h00000000;
			RFRD2_E <= 32'h00000000;
			EXTimm_E <= 32'h00000000;
		end
		else begin
			Instr_E <= Instr_D;
			PC_E <= PC_D;
			RFWA_E <= RFWA;
			RFRD1_E <= real_RFRD1;
			RFRD2_E <= real_RFRD2;
			EXTimm_E <= EXTimm;
		end
	end

endmodule
