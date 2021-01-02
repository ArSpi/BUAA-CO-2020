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
`include "define.v"
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
	output wire [4:0] RFWA_W,
	//P7 Bridge
	input wire [31:0] PrRD,
	output wire [31:0] PrAddr,
	output wire [31:0] PrWD,
	output wire PrWE,
	//P7 interrupt
	input wire [7:2] HWInt,
	output wire [31:0] macro_pc
    );
	
	/**********P7**********/
	assign PrAddr = ALUout_M;
	assign PrWD = real_DMWD;
	wire DevWD;
	Decoder code_cpu(.Instr(Instr_M), .DMWE(DevWD));
	assign PrWD = DevWD && (!IntReq && !ExcReq);
	/**********eret_signal**********/
	wire eret_D, eret_W;
	assign eret_D = ((Instr_D[31:26] == 6'b010000) && (Instr_D[5:0] == 6'b011000)) ? 1'b1 : 1'b0;
	assign eret_W = ((Instr_W[31:26] == 6'b010000) && (Instr_W[5:0] == 6'b011000)) ? 1'b1 : 1'b0;
	wire mtc0_E, mtc0_M;
	assign mtc0_E = ((Instr_E[31:26] == 6'b010000) && (Instr_E[25:21] == 5'b00100)) ? 1'b1 : 1'b0;
	assign mtc0_M = ((Instr_M[31:26] == 6'b010000) && (Instr_M[25:21] == 5'b00100)) ? 1'b1 : 1'b0;
	wire stall_eret;
	assign stall_eret = ((eret_D && mtc0_E) && (Instr_E[15:11] == 5'd14)) ? 1'b1 :
	                    ((eret_D && mtc0_M) && (Instr_M[15:11] == 5'd14)) ? 1'b1 :
							                                                      1'b0;
	/**********macro_pc & macro_borj**********/
	assign macro_pc = ((PC_M != 32'b0) || (ExcCode_CP0  != 5'b0)) ? PC_M :
	                  ((PC_E != 32'b0) || (ExcCode_Enew != 5'b0)) ? PC_E :
							((PC_D != 32'b0) || (ExcCode_Dnew != 5'b0)) ? PC_D :
							                                              32'b0;
	wire macro_borj;
	assign macro_borj = ((PC_M != 1'b0) || (ExcCode_CP0  != 5'b0)) ? BorJ_M :
	                    ((PC_E != 1'b0) || (ExcCode_Enew != 5'b0)) ? BorJ_E :
							  ((PC_D != 1'b0) || (ExcCode_Dnew != 5'b0)) ? BorJ_D :
							                                               1'b0;
	
	/**********接线定义**********/
	//F
	wire [31:0] NextPC, PC, Instr, PC4, NPC;
	wire AdEL_F;
	//D
	wire [31:0] PC_D, RFRD1, RFRD2, real_RFRD1, real_RFRD2, RFWD, EXTimm;
	wire [4:0] RFWA;
	wire zero, BorJ_D;
	wire [6:2] ExcCode_D;
	//E
	wire [31:0] PC_E, RFRD1_E, RFRD2_E, EXTimm_E, real_ALUA, real_ALUB, ALUout, HI, LO;
	wire [6:2] ExcCode_E;
	wire AdEL_E, AdEs_E, Ov_E, BorJ_E;
	//M
	wire [31:0] PC_M, ALUout_M, HI_M, LO_M, RFRD2_M, real_DMWD, DMRD, EPC, CP0RD;
	wire [6:2] ExcCode_M, ExcCode_CP0;
	wire IntReq, ExcReq, BorJ_M;
	//W
	wire [31:0] PC_W, ALUout_W, HI_W, LO_W, DMRD_W, CP0RD_W;
	
	//md阻塞
	wire start, busy, md, stall_md;
	Decoder code_md(.Instr(Instr_D), .md(md));
	assign stall_md = md && (start || busy);
	
	/**********F级**********/
	//PC, IM, ADD4, MPC
	PC pc(
		.clk(clk),
		.reset(reset),
		.NextPC(NextPC),
		.En_PC(En_PC),
		.stall_md(stall_md),
		.PC(PC),
		.IntReq(IntReq),
		.ExcReq(ExcReq),
		.eret_D(eret_D),
		.stall_eret(stall_eret)
	);
	
	IM im(
		.PC(PC),
		.Instr(Instr),
		.AdEL(AdEL_F)
	);
	
	ADD4 add4(
		.PC(PC),
		.PC4(PC4)
	);
	
	MPC mpc(
		.Instr_D(Instr_D),
		.IntReq(IntReq),
		.ExcReq(ExcReq),
		.NPC(NPC),
		.EPC(EPC),
		.PC4(PC4),
		.NextPC(NextPC)
	);
	
	/**********D级**********/
	//RegFD, NPC, CMP, RF, EXT, MRFWA, MFRD1D, MFRD2D
	RegFD RegFD(
		.clk(clk),
		.reset(reset),
		.En_RegFD(En_RegFD),
		.stall_md(stall_md),
		.Instr(Instr),
		.PC(PC),
		.Instr_D(Instr_D),
		.PC_D(PC_D),
		//
		.AdEL_F(AdEL_F),
		.eret_D(eret_D),
		.IntReq(IntReq),
		.ExcReq(ExcReq),
		.ExcCode_D(ExcCode_D),
		.BorJ_F(BorJ_F),
		.BorJ_D(BorJ_D),
		.stall_eret(stall_eret)
	);
	
	wire legal;
	wire [6:2] ExcCode_Dnew;
	Decoder code_legal(.Instr(Instr_D), .legal(legal));
	assign ExcCode_Dnew = ((!legal) && (ExcCode_D == 5'b0)) ? `RI : ExcCode_D;
	
	wire BorJ_F, beq, bne, blez, bgtz, bltz, bgez, j, jal, jr, jalr;
	Decoder code2_CP0(.Instr(Instr_D), .beq(beq), .bne(bne), .blez(blez), .bgtz(bgtz), .bltz(bltz), .bgez(bgez), .j(j), .jal(jal), .jr(jr), .jalr(jalr));
	assign BorJ_F = beq || bne || blez || bgtz || bltz || bgez || j || jal || jr || jalr;
	
	NPC npc(
		.Instr_D(Instr_D),
		.PC_D(PC_D),
		.real_RFRD1(real_RFRD1),
		.zero(zero),
		.NPC(NPC)
	);
	
	CMP cmp(
		.Instr_D(Instr_D),
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
		.HI_M(HI_M),
		.HI_W(HI_W),
		.LO_M(LO_M),
		.LO_W(LO_W),
		.DMRD_W(DMRD_W),
		.CP0RD_W(CP0RD_W),
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
		.HI_M(HI_M),
		.HI_W(HI_W),
		.LO_M(LO_M),
		.LO_W(LO_W),
		.DMRD_W(DMRD_W),
		.CP0RD_W(CP0RD_W),
		.RFRD2(RFRD2),
		.MFRD2D(MFRD2D),
		.real_RFRD2(real_RFRD2)
	);
	
	/**********E级**********/
	//RegDE, ALU, MFALUAE, MFALUBE, MDU
	RegDE RegDE(
		.clk(clk),
		.reset(reset),
		.Clr_RegDE(Clr_RegDE),
		.stall_md(stall_md),
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
		.EXTimm_E(EXTimm_E),
		//
		.IntReq(IntReq),
		.ExcReq(ExcReq),
		.ExcCode_Dnew(ExcCode_Dnew),
		.ExcCode_E(ExcCode_E),
		.BorJ_D(BorJ_D),
		.BorJ_E(BorJ_E),
		.stall_eret(stall_eret)
	);
	
	wire [6:2] ExcCode_Enew;
	assign ExcCode_Enew = ((AdEL_E) && (ExcCode_E == 5'b0)) ? `AdEL : 
	                      ((AdEs_E) && (ExcCode_E == 5'b0)) ? `AdEs :
							    ((Ov_E)   && (ExcCode_E == 5'b0)) ? `Ov   :
	                                                          ExcCode_E;
	
	ALU alu(
		.Instr_E(Instr_E),
		.rsvalue(real_ALUA),
		.rtvalue(real_ALUB),
		.EXTimm(EXTimm_E),
		.ALUout(ALUout),
		.AdEL_E(AdEL_E),
		.AdEs_E(AdEs_E),
		.Ov_E(Ov_E)
	);

	MFALUAE mfaluae(
		.PC_M(PC_M),
		.PC_W(PC_W),
		.ALUout_M(ALUout_M),
		.ALUout_W(ALUout_W),
		.HI_M(HI_M),
		.HI_W(HI_W),
		.LO_M(LO_M),
		.LO_W(LO_W),
		.DMRD_W(DMRD_W),
		.CP0RD_W(CP0RD_W),
		.RFRD1_E(RFRD1_E),
		.MFALUAE(MFALUAE),
		.real_ALUA(real_ALUA)
	);
	
	MFALUBE mfalube(
		.PC_M(PC_M),
		.PC_W(PC_W),
		.ALUout_M(ALUout_M),
		.ALUout_W(ALUout_W),
		.HI_M(HI_M),
		.HI_W(HI_W),
		.LO_M(LO_M),
		.LO_W(LO_W),
		.DMRD_W(DMRD_W),
		.CP0RD_W(CP0RD_W),
		.RFRD2_E(RFRD2_E),
		.MFALUBE(MFALUBE),
		.real_ALUB(real_ALUB)
	);
	
	MDU mdu(
		.clk(clk),
		.reset(reset),
		.Instr_E(Instr_E),
		.rsvalue(real_ALUA),
		.rtvalue(real_ALUB),
		.HI(HI),
		.LO(LO),
		.start(start),
		.busy(busy),
		.IntReq(IntReq),
		.ExcReq(ExcReq)
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
		.HI(HI),
		.LO(LO),
		.Instr_M(Instr_M),
		.PC_M(PC_M),
		.RFWA_M(RFWA_M),
		.ALUout_M(ALUout_M),
		.HI_M(HI_M),
		.LO_M(LO_M),
		.RFRD2_M(RFRD2_M),
		//
		.IntReq(IntReq),
		.ExcReq(ExcReq),
		.ExcCode_Enew(ExcCode_Enew),
		.ExcCode_M(ExcCode_M),
		.BorJ_E(BorJ_E),
		.BorJ_M(BorJ_M)
	);
	
	wire AdEL_M, AdEs_M;
	wire lb, lbu, lh, lhu, lw, sb, sh, sw;
	Decoder code_exc(.Instr(Instr_M), .lb(lb), .lbu(lbu), .lh(lh), .lhu(lhu), .lw(lw), .sb(sb), .sh(sh), .sw(sw));
	wire hit_DM, hit_Timer0, hit_Timer1, hit_Timer0_count, hit_Timer1_count;
	assign hit_DM = (32'h0000 <= PrAddr) && (PrAddr <= 32'h2fff);
	assign hit_Timer0 = (32'h7f00 <= PrAddr) && (PrAddr <= 32'h7f0b);
	assign hit_Timer0_count = (32'h7f08 <= PrAddr) && (PrAddr <= 32'h7f0b);
	assign hit_Timer1 = (32'h7f10 <= PrAddr) && (PrAddr <= 32'h7f1b);
	assign hit_Timer1_count = (32'h7f18 <= PrAddr) && (PrAddr <= 32'h7f1b);
	assign AdEL_M = ((lw)                           && (PrAddr[1:0] != 2'b00))     ||
	                ((lh || lhu)                    && (PrAddr[0] != 1'b0))        ||
						 ((lh || lhu || lb || lbu)       && (hit_Timer0 || hit_Timer1)) ||
						 ((lw || lh || lhu || lb || lbu) && !(hit_DM || hit_Timer0 || hit_Timer1));
	assign AdEs_M = (sw               && (PrAddr[1:0] != 2'b00))                 ||
	                (sh               && (PrAddr[0] != 1'b0))                    ||
						 ((sh || sb)       && (hit_Timer0 || hit_Timer1))             ||
						 ((sw || sh || sb) && (hit_Timer0_count || hit_Timer1_count)) ||
						 ((sw || sh || sb) && !(hit_DM || hit_Timer0 || hit_Timer1));
	assign ExcCode_CP0 = ((AdEL_M) && (ExcCode_M == 5'b0)) ? `AdEL :
	                     ((AdEs_M) && (ExcCode_M == 5'b0)) ? `AdEs :
						                                          ExcCode_M;
	
	DM dm(
		.clk(clk),
		.reset(reset),
		.Instr_M(Instr_M),
		.Addr(ALUout_M),
		.WD(real_DMWD),
		.PC(PC_M),
		.DMRD(DMRD),
		//from other devices
		.DevRD(PrRD),
		//I&E
		.IntReq(IntReq),
		.ExcReq(ExcReq)
	);
	
	MFWDM mfwdm(
		.PC_W(PC_W),
		.ALUout_W(ALUout_W),
		.HI_W(HI_W),
		.LO_W(LO_W),
		.DMRD_W(DMRD_W),
		.CP0RD_W(CP0RD_W),
		.RFRD2_M(RFRD2_M),
		.MFWDM(MFWDM),
		.real_DMWD(real_DMWD)
	);
	
	CP0 CP0(
		.clk(clk),
		.reset(reset),
		.Instr_M(Instr_M),
		.CP0Sel(Instr_M[15:11]),
		.CP0WD(real_DMWD),
		.CP0RD(CP0RD),
		.BorJ(macro_borj),
		.HWInt(HWInt),
		.ExcCode_CP0(ExcCode_CP0),
		.eret_CP0(eret_W),
		.PC_CP0(macro_pc),
		.EPC(EPC),
		.IntReq(IntReq),
		.ExcReq(ExcReq)
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
		.HI_M(HI_M),
		.LO_M(LO_M),
		.DMRD(DMRD),
		.CP0RD(CP0RD),
		.Instr_W(Instr_W),
		.PC_W(PC_W),
		.RFWA_W(RFWA_W),
		.ALUout_W(ALUout_W),
		.HI_W(HI_W),
		.LO_W(LO_W),
		.DMRD_W(DMRD_W),
		.CP0RD_W(CP0RD_W),
		.IntReq(IntReq),
		.ExcReq(ExcReq)
	);
	
	MRFWD mrfwd(
		.Instr_W(Instr_W),
		.ALUout_W(ALUout_W),
		.DMRD_W(DMRD_W),
		.PC_W(PC_W),
		.HI_W(HI_W),
		.LO_W(LO_W),
		.CP0RD_W(CP0RD_W),
		.RFWD(RFWD)
	);
	

endmodule
