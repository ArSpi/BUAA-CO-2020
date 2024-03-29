`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:34:05 11/29/2020 
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
`default_nettype none
module Datapath(
	input wire clk,
	input wire reset,
	input wire En_PC,
	input wire En_RegFD,
	input wire Clr_RegDE,
	input wire [3:0] MFRD1D,
	input wire [3:0] MFRD2D,
	input wire [3:0] MFALUAE,
	input wire [3:0] MFALUBE,
	input wire [3:0] MFWDM,
	output wire [31:0] Instr_D,
	output wire [31:0] Instr_E,
	output wire [31:0] Instr_M,
	output wire [31:0] Instr_W,
	output wire [4:0] RFWA_E,
	output wire [4:0] RFWA_M,
	output wire [4:0] RFWA_W
    );
	
	wire [31:0] NextPC, PC, Instr, PC4, NPC, PC_D, real_RFRD1, real_RFRD2, RFWD, PC_W, RFRD1, RFRD2, EXTimm;
	wire [31:0] PC_E, PC_M, ALUout_M, ALUout_W, DMRD_W, RFRD1_E, RFRD2_E, EXTimm_E, real_ALUA, real_ALUB;
	wire [31:0] ALUout, ALUB, RFRD2_M, real_DMWD, DMRD;
	wire [4:0] RFWA;
	wire zero;
	
	/**********F级**********/
	//PC, IM, ADD4, MPC
	PC pc(
		.clk(clk),
		.reset(reset),
		.NextPC(NextPC),
		.En_PC(En_PC),
		.PC(PC)
	);
	
	IM im(
		.PC(PC),
		.Instr(Instr)
	);
	
	ADD4 add4(
		.PC(PC),
		.PC4(PC4)
	);
	
	MPC mpc(
		.Instr_D(Instr_D),
		.NPC(NPC),
		.PC4(PC4),
		.NextPC(NextPC)
	);
	
	/**********D级**********/
	//RegFD, NPC, CMP, RF, EXT, MRFWA, MFRD1D, MFRD2D
	RegFD RegFD(
		.clk(clk),
		.reset(reset),
		.En_RegFD(En_RegFD),
		.Instr(Instr),
		.PC(PC),
		.Instr_D(Instr_D),
		.PC_D(PC_D)
	);
	
	NPC npc(
		.Instr_D(Instr_D),
		.PC_D(PC_D),
		.real_RFRD1(real_RFRD1),
		.zero(zero),
		.NPC(NPC)
	);
	
	CMP cmp(
		.real_RFRD1(real_RFRD1),
		.real_RFRD2(real_RFRD2),
		.zero(zero)
	);
	
	RF rf(
		.clk(clk),
		.reset(reset),
		.Instr_W(Instr_W),
		.RA1(Instr_D[25:21]),
		.RA2(Instr_D[20:16]),
		.WA(RFWA_W),
		.WD(RFWD),
		.PC_W(PC_W),
		.RD1(RFRD1),
		.RD2(RFRD2)
	);
	
	EXT ext(
		.Instr_D(Instr_D),
		.EXTimm(EXTimm)
	);
	
	MRFWA mrfwa(
		.Instr_D(Instr_D),
		.RFWA(RFWA)
	);
	
	MFRD1D mfrd1d(
		.PC_E(PC_E),
		.PC_M(PC_M),
		.PC_W(PC_W),
		.ALUout_M(ALUout_M),
		.ALUout_W(ALUout_W),
		.DMRD_W(DMRD_W),
		.RFRD1(RFRD1),
		.MFRD1D(MFRD1D),
		.real_RFRD1(real_RFRD1)
	);
	
	MFRD2D mfrd2d(
		.PC_E(PC_E),
		.PC_M(PC_M),
		.PC_W(PC_W),
		.ALUout_M(ALUout_M),
		.ALUout_W(ALUout_W),
		.DMRD_W(DMRD_W),
		.RFRD2(RFRD2),
		.MFRD2D(MFRD2D),
		.real_RFRD2(real_RFRD2)
	);
	
	/**********E级**********/
	//RegDE, ALU, MALUB, MFALUAE, MFALUBE
	RegDE RegDE(
		.clk(clk),
		.reset(reset),
		.Clr_RegDE(Clr_RegDE),
		.Instr_D(Instr_D),
		.PC_D(PC_D),
		.RFWA(RFWA),
		.real_RFRD1(real_RFRD1),
		.real_RFRD2(real_RFRD2),
		.EXTimm(EXTimm),
		.Instr_E(Instr_E),
		.PC_E(PC_E),
		.RFWA_E(RFWA_E),
		.RFRD1_E(RFRD1_E),
		.RFRD2_E(RFRD2_E),
		.EXTimm_E(EXTimm_E)
	);
	
	ALU alu(
		.Instr_E(Instr_E),
		.A(real_ALUA),
		.B(ALUB),
		.ALUout(ALUout)
	);
	
	MALUB malub(
		.Instr_E(Instr_E),
		.real_ALUB(real_ALUB),
		.EXTimm_E(EXTimm_E),
		.ALUB(ALUB)
	);
	
	MFALUAE mfaluae(
		.PC_M(PC_M),
		.PC_W(PC_W),
		.ALUout_M(ALUout_M),
		.ALUout_W(ALUout_W),
		.DMRD_W(DMRD_W),
		.RFRD1_E(RFRD1_E),
		.MFALUAE(MFALUAE),
		.real_ALUA(real_ALUA)
	);
	
	MFALUBE mfalube(
		.PC_M(PC_M),
		.PC_W(PC_W),
		.ALUout_M(ALUout_M),
		.ALUout_W(ALUout_W),
		.DMRD_W(DMRD_W),
		.RFRD2_E(RFRD2_E),
		.MFALUBE(MFALUBE),
		.real_ALUB(real_ALUB)
	);
	
	/**********M级**********/
	//RegEM, DM, MFWDM
	RegEM RegEM(
		.clk(clk),
		.reset(reset),
		.Instr_E(Instr_E),
		.PC_E(PC_E),
		.RFWA_E(RFWA_E),
		.RFRD2_E(real_ALUB),
		.ALUout(ALUout),
		.Instr_M(Instr_M),
		.PC_M(PC_M),
		.RFWA_M(RFWA_M),
		.ALUout_M(ALUout_M),
		.RFRD2_M(RFRD2_M)
	);
	
	DM dm(
		.clk(clk),
		.reset(reset),
		.Instr_M(Instr_M),
		.Addr(ALUout_M),
		.WD(real_DMWD),
		.PC(PC_M),
		.RD(DMRD)
	);
	
	MFWDM mfwdm(
		.PC_W(PC_W),
		.ALUout_W(ALUout_W),
		.DMRD_W(DMRD_W),
		.RFRD2_M(RFRD2_M),
		.MFWDM(MFWDM),
		.real_DMWD(real_DMWD)
	);
	
	/**********W级**********/
	//RegMW, MRFWD
	RegMW RegMW(
		.clk(clk),
		.reset(reset),
		.Instr_M(Instr_M),
		.PC_M(PC_M),
		.RFWA_M(RFWA_M),
		.ALUout_M(ALUout_M),
		.DMRD(DMRD),
		.Instr_W(Instr_W),
		.PC_W(PC_W),
		.RFWA_W(RFWA_W),
		.ALUout_W(ALUout_W),
		.DMRD_W(DMRD_W)
	);
	
	MRFWD mrfwd(
		.Instr_W(Instr_W),
		.ALUout_W(ALUout_W),
		.DMRD_W(DMRD_W),
		.PC_W(PC_W),
		.RFWD(RFWD)
	);
	

endmodule
