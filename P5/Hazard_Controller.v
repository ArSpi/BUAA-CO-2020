`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:34:11 11/29/2020 
// Design Name: 
// Module Name:    Hazard_Controller 
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
module Hazard_Controller(
	input wire [31:0] Instr_D,
	input wire [31:0] Instr_E,
	input wire [31:0] Instr_M,
	input wire [31:0] Instr_W,
	input wire [4:0] RFWA_E,
	input wire [4:0] RFWA_M,
	input wire [4:0] RFWA_W,
	output reg En_PC,
	output reg En_RegFD,
	output reg Clr_RegDE,
	output wire [3:0] MFRD1D,
	output wire [3:0] MFRD2D,
	output wire [3:0] MFALUAE,
	output wire [3:0] MFALUBE,
	output wire [3:0] MFWDM
    );
	/*****译码*****/
	wire Tuse_rs0, Tuse_rs1, Tuse_rt0, Tuse_rt1, Tuse_rt2;
	wire [4:0] RS_D, RT_D, RD_D;
	Decoder code_D(.Instr(Instr_D), .Tuse_rs0(Tuse_rs0), .Tuse_rs1(Tuse_rs1), .Tuse_rt0(Tuse_rt0), .Tuse_rt1(Tuse_rt1), .Tuse_rt2(Tuse_rt2));
	assign RS_D = Instr_D[25:21];
	assign RT_D = Instr_D[20:16];
	assign RD_D = Instr_D[15:11];
	
	wire [2:0] Tnew_E;
	wire [3:0] RFWD_E;
	wire [4:0] RS_E, RT_E, RD_E;
	Decoder code_E(.Instr(Instr_E), .Tnew_E(Tnew_E), .MRFWD(RFWD_E));
	assign RS_E = Instr_E[25:21];
	assign RT_E = Instr_E[20:16];
	assign RD_E = Instr_E[15:11];
	
	wire [2:0] Tnew_M;
	wire [3:0] RFWD_M;
	wire [4:0] RS_M, RT_M, RD_M;
	Decoder code_M(.Instr(Instr_M), .Tnew_M(Tnew_M), .MRFWD(RFWD_M));
	assign RS_M = Instr_M[25:21];
	assign RT_M = Instr_M[20:16];
	assign RD_M = Instr_M[15:11];
	
	wire [2:0] Tnew_W;
	wire [3:0] RFWD_W;
	wire [4:0] RS_W, RT_W, RD_W;
	Decoder code_W(.Instr(Instr_W), .Tnew_W(Tnew_W), .MRFWD(RFWD_W));
	assign RS_W = Instr_W[25:21];
	assign RT_W = Instr_W[20:16];
	assign RD_W = Instr_W[15:11];
	
	/*****暂停信号*****/
	wire Stall_RS0_E1, Stall_RS0_E2, Stall_RS0_M1, Stall_RS1_E2;
	wire Stall_RT0_E1, Stall_RT0_E2, Stall_RT0_M1, Stall_RT1_E2;
	wire Stall_RS, Stall_RT;
	wire Stall;
	
	assign Stall_RS0_E1 = ((Tuse_rs0) && (Tnew_E == 2'b01) && (RS_D == RFWA_E) && (RS_D != 5'b0)) ? 1'b1 : 1'b0;
	assign Stall_RS0_E2 = ((Tuse_rs0) && (Tnew_E == 2'b10) && (RS_D == RFWA_E) && (RS_D != 5'b0)) ? 1'b1 : 1'b0;
	assign Stall_RS0_M1 = ((Tuse_rs0) && (Tnew_M == 2'b01) && (RS_D == RFWA_M) && (RS_D != 5'b0)) ? 1'b1 : 1'b0;
	assign Stall_RS1_E2 = ((Tuse_rs1) && (Tnew_E == 2'b10) && (RS_D == RFWA_E) && (RS_D != 5'b0)) ? 1'b1 : 1'b0;
	
	assign Stall_RT0_E1 = ((Tuse_rt0) && (Tnew_E == 2'b01) && (RT_D == RFWA_E) && (RT_D != 5'b0)) ? 1'b1 : 1'b0;
	assign Stall_RT0_E2 = ((Tuse_rt0) && (Tnew_E == 2'b10) && (RT_D == RFWA_E) && (RT_D != 5'b0)) ? 1'b1 : 1'b0;
	assign Stall_RT0_M1 = ((Tuse_rt0) && (Tnew_M == 2'b01) && (RT_D == RFWA_M) && (RT_D != 5'b0)) ? 1'b1 : 1'b0;
	assign Stall_RT1_E2 = ((Tuse_rt1) && (Tnew_E == 2'b10) && (RT_D == RFWA_E) && (RT_D != 5'b0)) ? 1'b1 : 1'b0;
	
	assign Stall_RS = Stall_RS0_E1 || Stall_RS0_E2 || Stall_RS0_M1 || Stall_RS1_E2;
	assign Stall_RT = Stall_RT0_E1 || Stall_RT0_E2 || Stall_RT0_M1 || Stall_RT1_E2;
	
	assign Stall = Stall_RS || Stall_RT;
	
	/*****暂停操作*****/
	always @(*) begin
		En_PC     = (Stall) ? 1'b0 : 1'b1;
		En_RegFD  = (Stall) ? 1'b0 : 1'b1;
		Clr_RegDE = (Stall) ? 1'b1 : 1'b0;
	end
	
	/*****转发多路选择器信号*****/
	assign MFRD1D = ((RS_D == RFWA_E) && (RS_D != 5'b0) && (RFWD_E == `PC))  ? `EtoD_PC8 :
                   ((RS_D == RFWA_M) && (RS_D != 5'b0) && (RFWD_M == `PC))  ? `MtoD_PC8 :
						 ((RS_D == RFWA_M) && (RS_D != 5'b0) && (RFWD_M == `ALU)) ? `MtoD_ALU :
						 ((RS_D == RFWA_W) && (RS_D != 5'b0) && (RFWD_W == `PC))  ? `WtoD_PC8 :
						 ((RS_D == RFWA_W) && (RS_D != 5'b0) && (RFWD_W == `ALU)) ? `WtoD_ALU :
						 ((RS_D == RFWA_W) && (RS_D != 5'b0) && (RFWD_W == `DM))  ? `WtoD_DM  :
						                                                            `NoForward;
	
	assign MFRD2D = ((RT_D == RFWA_E) && (RT_D != 5'b0) && (RFWD_E == `PC))  ? `EtoD_PC8 :
                   ((RT_D == RFWA_M) && (RT_D != 5'b0) && (RFWD_M == `PC))  ? `MtoD_PC8 :
						 ((RT_D == RFWA_M) && (RT_D != 5'b0) && (RFWD_M == `ALU)) ? `MtoD_ALU :
						 ((RT_D == RFWA_W) && (RT_D != 5'b0) && (RFWD_W == `PC))  ? `WtoD_PC8 :
						 ((RT_D == RFWA_W) && (RT_D != 5'b0) && (RFWD_W == `ALU)) ? `WtoD_ALU :
						 ((RT_D == RFWA_W) && (RT_D != 5'b0) && (RFWD_W == `DM))  ? `WtoD_DM  :
						                                                            `NoForward;
	
	assign MFALUAE = ((RS_E == RFWA_M) && (RS_E != 5'b0) && (RFWD_M == `PC))  ? `MtoE_PC8 :
	                 ((RS_E == RFWA_M) && (RS_E != 5'b0) && (RFWD_M == `ALU)) ? `MtoE_ALU :
						  ((RS_E == RFWA_W) && (RS_E != 5'b0) && (RFWD_W == `PC))  ? `WtoE_PC8 :
						  ((RS_E == RFWA_W) && (RS_E != 5'b0) && (RFWD_W == `ALU)) ? `WtoE_ALU :
						  ((RS_E == RFWA_W) && (RS_E != 5'b0) && (RFWD_W == `DM))  ? `WtoE_DM  :
						                                                             `NoForward;
	
   assign MFALUBE = ((RT_E == RFWA_M) && (RT_E != 5'b0) && (RFWD_M == `PC))  ? `MtoE_PC8 :
	                 ((RT_E == RFWA_M) && (RT_E != 5'b0) && (RFWD_M == `ALU)) ? `MtoE_ALU :
						  ((RT_E == RFWA_W) && (RT_E != 5'b0) && (RFWD_W == `PC))  ? `WtoE_PC8 :
						  ((RT_E == RFWA_W) && (RT_E != 5'b0) && (RFWD_W == `ALU)) ? `WtoE_ALU :
						  ((RT_E == RFWA_W) && (RT_E != 5'b0) && (RFWD_W == `DM))  ? `WtoE_DM  :
						                                                             `NoForward;
	
   assign MFWDM = ((RT_M == RFWA_W) && (RT_M != 5'b0) && (RFWD_W == `PC))  ? `WtoM_PC8 :
	               ((RT_M == RFWA_W) && (RT_M != 5'b0) && (RFWD_W == `ALU)) ? `WtoM_ALU :
						((RT_M == RFWA_W) && (RT_M != 5'b0) && (RFWD_W == `DM))  ? `WtoM_DM  :
						                                                           `NoForward;
	
endmodule
//其实这里全改成RFWA!=5'b0会更直观一些，但是不改理论上也能跑就是了