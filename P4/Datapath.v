`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:09:31 11/15/2020 
// Design Name: 
// Module Name:    Datapath 
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
`include "IFU.v"
`include "GRF.v"
`include "ALU.v"
`include "DM.v"
`include "EXT.v"
`include "MUX.v"
module Datapath(
	input clk,
	input reset,
	input [1:0] MUX1,
	input MUX2,
	input [1:0] MUX3,
	input GRFWE,
	input DMWE,
	input DMRE,
	input [1:0] NPCOp,
	input [1:0] ALUOp,
	input [1:0] EXTOp,
	output [31:0] Instr
    );
	
	wire zero;
	wire [4:0] GRF_WA;
	wire [31:0] rsvalue, rtvalue, PC4, GRF_WD, ALU_num2, ALU_result, DM_RD, EXT_EXTimm;
	
	IFU ifu(
		.clk(clk),
		.reset(reset),
		.zero(zero),
		.NPCOp(NPCOp),
		.rsvalue(rsvalue),
		
		.Instr(Instr),
		.PC4(PC4)
	);
	
	GRF grf(
		.clk(clk),
		.reset(reset),
		.WE(GRFWE),
		.RA1(Instr[25:21]),
		.RA2(Instr[20:16]),
		.WA(GRF_WA),
		.WD(GRF_WD),
		.PC4(PC4),
		
		.RD1(rsvalue),
		.RD2(rtvalue)
	);
	
	ALU alu(
		.num1(rsvalue),
		.num2(ALU_num2),
		.ALUOp(ALUOp),
		
		.result(ALU_result),
		.zero(zero)
	);
	
	DM dm(
		.clk(clk),
		.reset(reset),
		.Addr(ALU_result),
		.WD(rtvalue),
		.WE(DMWE),
		.RE(DMRE),
		.PC4(PC4),
		
		.RD(DM_RD)
	);
	
	EXT ext(
		.imm(Instr[15:0]),
		.EXTOp(EXTOp),
		
		.EXTimm(EXT_EXTimm)
	);
	
	MUX1 mux1(
		.IFU_Instr(Instr),
		.MUX1(MUX1),
		
		.GRF_WA(GRF_WA)
	);
	
	MUX2 mux2(
		.GRF_RD2(rtvalue),
		.EXT_EXTimm(EXT_EXTimm),
		.MUX2(MUX2),
		
		.ALU_num2(ALU_num2)
	);
	
	MUX3 mux3(
		.ALU_result(ALU_result),
		.DM_RD(DM_RD),
		.MUX3(MUX3),
		.PC4(PC4),
		
		.GRF_WD(GRF_WD)
	);

endmodule
