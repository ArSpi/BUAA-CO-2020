`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:36:16 11/29/2020 
// Design Name: 
// Module Name:    define 
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

/**********Decoder**********/
//译码
`define R 6'b000000
	`define addu 6'b100001
	`define subu 6'b100011
	`define nop 6'b000000
	`define jr 6'b001000
`define ori 6'b001101
`define lw 6'b100011
`define sw 6'b101011
`define beq 6'b000100
`define lui 6'b001111
`define jal 6'b000011
`define j 6'b000010
//功能控制信号MPC  &&  MPC模块
`define PC4 4'b0000
`define NPC 4'b0001
//功能控制信号MRFWA  &&  MRFWA模块		// not zero
`define rt 4'b0001
`define rd 4'b0010
`define ra 4'b0011
//功能控制信号MALUB  &&  MALUB模块
`define real_ALUB 4'b0000
`define EXTimm 4'b0001
//功能控制信号MRFWD  &&  MRFWD模块
`define ALUout 4'b0000
`define DMRD 4'b0001
`define PC8 4'b0010
//功能控制信号NPCOp  &&  NPC模块			// not zero
`define isb 4'b0001
`define isj 4'b0010
`define isjr 4'b0011
//功能控制信号ALUOp  &&  ALU模块
`define ADD 4'b0000
`define SUB 4'b0001
`define OR 4'b0010
//功能控制信号EXTOp  &&  EXT模块
`define sign_ext 4'b0000
`define zero_ext 4'b0001
`define high_ext 4'b0010
//Tnew
`define No_result 3'b000



/**********Hazard_Controller**********/
//RFWD转发选择信号
`define ALU 4'b0000
`define DM 4'b0001
`define PC 4'b0010
//转发多路选择器控制信号
`define NoForward 4'b0000

`define EtoD_PC8 4'b0001
`define MtoD_PC8 4'b0010
`define MtoD_ALU 4'b0011
`define WtoD_PC8 4'b0100
`define WtoD_ALU 4'b0101
`define WtoD_DM 4'b0110

`define MtoE_PC8 4'b0001
`define MtoE_ALU 4'b0010
`define WtoE_PC8 4'b0011
`define WtoE_ALU 4'b0100
`define WtoE_DM 4'b0101

`define WtoM_PC8 4'b0001
`define WtoM_ALU 4'b0010
`define WtoM_DM 4'b0011