`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:50:12 11/29/2020 
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
`default_nettype none
module CPU(
	input wire clk,
	input wire reset,
	//P7 Bridge
	input wire [31:0] PrRD,
	output wire [31:0] PrAddr,
	output wire [31:0] PrWD,
	output wire PrWE,
	//P7 interrupt
	input wire [7:2] HWInt,
	output wire [31:0] macro_pc
    );
	
	/****************************/
	
	wire [31:0] Instr_D, Instr_E, Instr_M, Instr_W;
	wire [4:0] RFWA_E, RFWA_M, RFWA_W;
	wire [3:0] MFRD1D, MFRD2D, MFALUAE, MFALUBE, MFWDM;
	wire En_PC, En_RegFD, Clr_RegDE;
	
	Datapath datapath(
		.clk(clk),
		.reset(reset),
		.En_PC(En_PC),
		.En_RegFD(En_RegFD),
		.Clr_RegDE(Clr_RegDE),
		.MFRD1D(MFRD1D),
		.MFRD2D(MFRD2D),
		.MFALUAE(MFALUAE),
		.MFALUBE(MFALUBE),
		.MFWDM(MFWDM),
		.Instr_D(Instr_D),
		.Instr_E(Instr_E),
		.Instr_M(Instr_M),
		.Instr_W(Instr_W),
		.RFWA_E(RFWA_E),
		.RFWA_M(RFWA_M),
		.RFWA_W(RFWA_W),
		//P7 Bridge
		.PrRD(PrRD),
		.PrAddr(PrAddr),
		.PrWD(PrWD),
		.PrWE(PrWE),
		.HWInt(HWInt),
		.macro_pc(macro_pc)
	);
	
	Hazard_Controller ctrl(
		.Instr_D(Instr_D),
		.Instr_E(Instr_E),
		.Instr_M(Instr_M),
		.Instr_W(Instr_W),
		.RFWA_E(RFWA_E),
		.RFWA_M(RFWA_M),
		.RFWA_W(RFWA_W),
		.En_PC(En_PC),
		.En_RegFD(En_RegFD),
		.Clr_RegDE(Clr_RegDE),
		.MFRD1D(MFRD1D),
		.MFRD2D(MFRD2D),
		.MFALUAE(MFALUAE),
		.MFALUBE(MFALUBE),
		.MFWDM(MFWDM)
	);

endmodule
