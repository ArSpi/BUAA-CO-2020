`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:34:27 11/29/2020 
// Design Name: 
// Module Name:    Decoder 
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
`include "define.v"
`default_nettype none
module Decoder(
	input wire [31:0] Instr,
	output reg [3:0] MPC,
	output reg [3:0] MRFWA,
	output reg [3:0] MALUB,
	output reg [3:0] MRFWD,
	output reg RFWE,
	output reg DMWE,
	output reg [3:0] NPCOp,
	output reg [3:0] ALUOp,
	output reg [3:0] EXTOp,
	output reg Tuse_rs0,
	output reg Tuse_rs1,
	output reg Tuse_rt0,
	output reg Tuse_rt1,
	output reg Tuse_rt2,
	output reg [2:0] Tnew_E,
	output reg [2:0] Tnew_M,
	output reg [2:0] Tnew_W
    );
	
	/*****译码*****/
	wire [5:0] opcode, funct;
	assign opcode = Instr[31:26];
	assign funct = Instr[5:0];
	
	wire addu, subu, ori, lw, sw, beq, lui, j, jal, jr, nop;
	assign addu = ((opcode == `R) && (funct == `addu)) ? 1'b1 : 1'b0;
	assign subu = ((opcode == `R) && (funct == `subu)) ? 1'b1 : 1'b0;
	assign jr   = ((opcode == `R) && (funct == `jr))   ? 1'b1 : 1'b0;
	assign nop  = ((opcode == `R) && (funct == `nop))  ? 1'b1 : 1'b0;
	assign ori  = (opcode == `ori)                     ? 1'b1 : 1'b0;
	assign lw   = (opcode == `lw)                      ? 1'b1 : 1'b0;
	assign sw   = (opcode == `sw)                      ? 1'b1 : 1'b0;
	assign beq  = (opcode == `beq)                     ? 1'b1 : 1'b0;
	assign lui  = (opcode == `lui)                     ? 1'b1 : 1'b0;
	assign j    = (opcode == `j)                       ? 1'b1 : 1'b0;
	assign jal  = (opcode == `jal)                     ? 1'b1 : 1'b0;
	
	/*****功能控制信号*****/
	always @(*) begin
		MPC = (beq || j || jal || jr) ? `NPC :
                                      `PC4;
		
		MRFWA = (ori || lui || lw) ? `rt :
		        (addu || subu)     ? `rd :
				  (jal)              ? `ra :
					                    4'b0000;
		
		MALUB = (addu || subu)           ? `real_ALUB :
		        (ori || lw || sw || lui) ? `EXTimm    :
				                             4'b0000;
		
		MRFWD = (addu || subu || ori ||lui) ? `ALUout :
		        (lw)                        ? `DMRD   :
				  (jal)                       ? `PC8	 :
					                              4'b0000;
		
		RFWE = (addu || subu || ori || lw || lui || jal) ? 1'b1 : 1'b0;
		
		DMWE = (sw) ? 1'b1 : 1'b0;
		
		NPCOp = (beq)      ? `isb  :
		        (j || jal) ? `isj  :
				  (jr)       ? `isjr :
				               4'b0000;
		
		ALUOp = (addu || lw || sw) ? `ADD :
		        (subu)             ? `SUB :
				  (ori || lui)       ? `OR  :
				                       4'b0000;
		
		EXTOp = (lw || sw) ? `sign_ext :
		        (ori)      ? `zero_ext :
				  (lui)      ? `high_ext :
				               4'b0000;
	end
	
	/*****Tuse*****/
	always @(*) begin
		Tuse_rs0 = beq || jr;
		Tuse_rs1 = addu || subu || ori || lw || sw;
		Tuse_rt0 = beq;
		Tuse_rt1 = addu || subu;
		Tuse_rt2 = sw;
	end
	
	/*****Tnew*****/
	always @(*) begin
		Tnew_E = (lw)                         ? 3'd2 :
		         (addu || subu || ori || lui) ? 3'd1 :
					(jal)                        ? 3'd0 :
					                               `No_result;
		Tnew_M = (Tnew_E != 3'd0) ? (Tnew_E - 3'd1) : 3'd0;
		Tnew_W = (Tnew_M != 3'd0) ? (Tnew_M - 3'd1) : 3'd0;
	end

endmodule
