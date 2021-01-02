`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:40:53 11/30/2020 
// Design Name: 
// Module Name:    RegEM 
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
module RegEM(
	input wire clk,
	input wire reset,
	input wire [31:0] Instr_E,
	input wire [31:0] PC_E,
	input wire [4:0] RFWA_E,
	input wire [31:0] RFRD2_E,
	input wire [31:0] ALUout,
	input wire [31:0] HI,
	input wire [31:0] LO,
	output reg [31:0] Instr_M,
	output reg [31:0] PC_M,
	output reg [4:0] RFWA_M,
	output reg [31:0] ALUout_M,
	output reg [31:0] HI_M,
	output reg [31:0] LO_M,
	output reg [31:0] RFRD2_M
    );
	always @(posedge clk) begin
		if (reset) begin
			Instr_M <= 32'h00000000;
			PC_M <= 32'h00003000;
			RFWA_M <= 5'b00000;
			ALUout_M <= 32'h00000000;
			HI_M <= 32'h00000000;
			LO_M <= 32'h00000000;
			RFRD2_M <= 32'h00000000;
		end
		else begin
			Instr_M <= Instr_E;
			PC_M <= PC_E;
			RFWA_M <= RFWA_E;
			ALUout_M <= ALUout;
			HI_M <= HI;
			LO_M <= LO;
			RFRD2_M <= RFRD2_E;
		end
	end

endmodule
