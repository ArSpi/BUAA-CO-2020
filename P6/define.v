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
	`define add 6'b100000
	`define addu 6'b100001
	`define sub 6'b100010
	`define subu 6'b100011
	`define sll 6'b000000
	`define srl 6'b000010
	`define sra 6'b000011
	`define sllv 6'b000100
	`define srlv 6'b000110
	`define srav 6'b000111
	`define andd 6'b100100
	`define orr 6'b100101
	`define xorr 6'b100110
	`define norr 6'b100111
	`define slt 6'b101010
	`define sltu 6'b101011
	`define mult 6'b011000
	`define multu 6'b011001
	`define div 6'b011010
	`define divu 6'b011011
	`define mfhi 6'b010000
	`define mflo 6'b010010
	`define mthi 6'b010001
	`define mtlo 6'b010011
	`define jr 6'b001000
	`define jalr 6'b001001
`define addi 6'b001000
`define addiu 6'b001001
`define andi 6'b001100
`define ori 6'b001101
`define xori 6'b001110
`define lui 6'b001111
`define slti 6'b001010
`define sltiu 6'b001011
`define lb 6'b100000
`define lbu 6'b100100
`define lh 6'b100001
`define lhu 6'b100101
`define lw 6'b100011
`define sb 6'b101000
`define sh 6'b101001
`define sw 6'b101011
`define beq 6'b000100
`define bne 6'b000101
`define blez 6'b000110
`define bgtz 6'b000111
`define REGIMM 6'b000001
	`define bltz 5'b00000
	`define bgez 5'b00001
`define j 6'b000010
`define jal 6'b000011
//功能控制信号MPC  &&  MPC模块
`define PC4 4'b0000
`define NPC 4'b0001
//功能控制信号MRFWA  &&  MRFWA模块		// not zero
`define rt 4'b0001
`define rd 4'b0010
`define ra 4'b0011
//功能控制信号MALUA
`define rsvalue 4'b0000
`define shamt 4'b0001
//功能控制信号MALUB  &&  MALUB模块
`define rtvalue 4'b0000
`define EXTimm 4'b0001
//功能控制信号MRFWD  &&  MRFWD模块
`define ALUout 4'b0000
`define DMRD 4'b0001
`define PC8 4'b0010
`define HI 4'b0011
`define LO 4'b0100
//功能控制信号NPCOp  &&  NPC模块			// not zero
`define isb 4'b0001
`define isj 4'b0010
`define isjr 4'b0011
//功能控制信号ALUOp  &&  ALU模块
`define ADD 4'b0000
`define SUB 4'b0001
`define AND 4'b0010
`define OR  4'b0011
`define XOR 4'b0100
`define NOR 4'b0101
`define LEFT 4'b0110
`define zero_RIGHT 4'b0111
`define sign_RIGHT 4'b1000
`define zero_LESS 4'b1001
`define sign_LESS 4'b1010
//功能控制信号EXTOp  &&  EXT模块
`define sign_ext 4'b0000
`define zero_ext 4'b0001
`define high_ext 4'b0010
//功能控制信号MDUwrite
`define whi 4'b0001
`define wlo 4'b0010
//功能控制信号MDUcal
`define sign_mult 4'b0001
`define zero_mult 4'b0010
`define sign_div 4'b0011
`define zero_div 4'b1000
//Tnew
`define No_result 3'b000



/**********Hazard_Controller**********/
//RFWD转发选择信号
`define ALU 4'b0000
`define DM 4'b0001
`define PC 4'b0010 /*
`define HI 4'b0011
`define LO 4'b0100 */
//转发多路选择器控制信号
`define NoForward 4'b0000

`define EtoD_PC8 4'b0001
`define MtoD_PC8 4'b0010
`define MtoD_ALU 4'b0011
`define MtoD_HI 4'b0100
`define MtoD_LO 4'b0101
`define WtoD_PC8 4'b0110
`define WtoD_ALU 4'b0111
`define WtoD_HI 4'b1000
`define WtoD_LO 4'b1001
`define WtoD_DM 4'b1010

`define MtoE_PC8 4'b0001
`define MtoE_ALU 4'b0010
`define MtoE_HI 4'b0011
`define MtoE_LO 4'b0100
`define WtoE_PC8 4'b0101
`define WtoE_ALU 4'b0110
`define WtoE_HI 4'b0111
`define WtoE_LO 4'b1000
`define WtoE_DM 4'b1001

`define WtoM_PC8 4'b0001
`define WtoM_ALU 4'b0010
`define WtoM_HI 4'b0011
`define WtoM_LO 4'b0100
`define WtoM_DM 4'b0101