`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:51:55 11/19/2020 
// Design Name: 
// Module Name:    mips 
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
`include "Datapath.v"
`include "Controller.v"
module mips(
    input clk,
    input reset
    );
	
	wire MUX2, GRFWE, DMWE, DMRE;
	wire [1:0] MUX1, MUX3, ALUOp, EXTOp, NPCOp;
	wire [31:0] Instr;
	
	Datapath dp(
		.clk(clk),
		.reset(reset),
		.MUX1(MUX1),
		.MUX2(MUX2),
		.MUX3(MUX3),
		.GRFWE(GRFWE),
		.DMWE(DMWE),
		.DMRE(DMRE),
		.NPCOp(NPCOp),
		.ALUOp(ALUOp),
		.EXTOp(EXTOp),
		.Instr(Instr)
	);
	
	Controller ctrl(
		.Instr(Instr),
		.MUX1(MUX1),
		.MUX2(MUX2),
		.MUX3(MUX3),
		.GRFWE(GRFWE),
		.DMWE(DMWE),
		.DMRE(DMRE),
		.NPCOp(NPCOp),
		.ALUOp(ALUOp),
		.EXTOp(EXTOp)
	);
	
endmodule

