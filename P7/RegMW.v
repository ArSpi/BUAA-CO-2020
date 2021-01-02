`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:41:09 11/30/2020 
// Design Name: 
// Module Name:    RegMW 
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
module RegMW(
	input wire clk,
	input wire reset,
	input wire [31:0] Instr_M,
	input wire [31:0] PC_M,
	input wire [4:0] RFWA_M,
	input wire [31:0] ALUout_M,
	input wire [31:0] HI_M,
	input wire [31:0] LO_M,
	input wire [31:0] DMRD,
	input wire [31:0] CP0RD,
	output reg [31:0] Instr_W,
	output reg [31:0] PC_W,
	output reg [4:0] RFWA_W,
	output reg [31:0] ALUout_W,
	output reg [31:0] HI_W,
	output reg [31:0] LO_W,
	output reg [31:0] DMRD_W,
	output reg [31:0] CP0RD_W,
	//
	input wire IntReq,
	input wire ExcReq
    );
	always @(posedge clk) begin
		if (reset || IntReq || ExcReq) begin
			Instr_W <= 32'h00000000;
			PC_W <= (reset) ? 32'h00003000 : 32'b0;
			RFWA_W <= 5'b00000;
			ALUout_W <= 32'h00000000;
			HI_W <= 32'h00000000;
			LO_W <= 32'h00000000;
			DMRD_W <= 32'h00000000;
			CP0RD_W <= 32'h00000000;
		end
		else begin
			Instr_W <= Instr_M;
			PC_W <= PC_M;
			RFWA_W <= RFWA_M;
			ALUout_W <= ALUout_M;
			HI_W <= HI_M;
			LO_W <= LO_M;
			DMRD_W <= DMRD;
			CP0RD_W <= CP0RD;
		end
	end

endmodule
