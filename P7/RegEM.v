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
`include "define.v"
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
	output reg [31:0] RFRD2_M,
	//
	input wire IntReq,
	input wire ExcReq,
	input wire [6:2] ExcCode_Enew,
	output reg [6:2] ExcCode_M,
	input wire BorJ_E,
	output reg BorJ_M
    );
	always @(posedge clk) begin
		if (reset || IntReq || ExcReq) begin
			Instr_M <= 32'h00000000;
			PC_M <= (reset) ? 32'h00003000 : 32'b0;
			RFWA_M <= 5'b00000;
			ALUout_M <= 32'h00000000;
			HI_M <= 32'h00000000;
			LO_M <= 32'h00000000;
			RFRD2_M <= 32'h00000000;
			ExcCode_M <= 5'b00000;
			BorJ_M <= 1'b0;
		end
		else begin
			Instr_M <= Instr_E;
			PC_M <= PC_E;
			RFWA_M <= RFWA_E;
			ALUout_M <= ALUout;
			HI_M <= HI;
			LO_M <= LO;
			RFRD2_M <= RFRD2_E;
			ExcCode_M <= ExcCode_Enew;
			BorJ_M <= BorJ_E;
		end
	end
	
endmodule
