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
`include "define.v"
module RegFD(
	input wire clk,
	input wire reset,
	input wire En_RegFD,
	input wire stall_md,
	input wire [31:0] Instr,
	input wire [31:0] PC,
	output reg [31:0] Instr_D,
	output reg [31:0] PC_D,
	//Exception
	input wire AdEL_F,
	input wire eret_D,
	input wire IntReq,
	input wire ExcReq,
	output reg [6:2] ExcCode_D,
	input wire BorJ_F,
	output reg BorJ_D,
	input wire stall_eret
    );
	always @(posedge clk) begin
		if (reset || IntReq || ExcReq) begin
			Instr_D <= 32'h00000000;
			PC_D <= (reset) ? 32'h00003000 : 32'b0;
			ExcCode_D <= 5'b00000;
			BorJ_D <= 1'b0;
		end
		else begin
			if (!stall_eret) begin
				if (eret_D) begin
					Instr_D <= 32'h00000000;
					PC_D <= 32'b0;
					ExcCode_D <= 5'b00000;
					BorJ_D <= 1'b0;
				end
				else if (En_RegFD && !stall_md) begin
					Instr_D <= (AdEL_F) ? 32'b0 : Instr;
					PC_D <= PC;
					ExcCode_D <= (AdEL_F) ? `AdEL : 5'b0;
					BorJ_D <= BorJ_F;
				end
			end
		end
	end
	
endmodule
