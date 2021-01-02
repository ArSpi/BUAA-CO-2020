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
	output reg [3:0] MALUA,
	output reg [3:0] MALUB,
	output reg [3:0] MRFWD,
	output reg DMWE,
	output reg [3:0] NPCOp,
	output reg [3:0] ALUOp,
	output reg [3:0] EXTOp,
	output reg [3:0] MDUwrite,
	output reg [3:0] MDUcal,
	output reg start,
	output reg Tuse_rs0,
	output reg Tuse_rs1,
	output reg Tuse_rt0,
	output reg Tuse_rt1,
	output reg Tuse_rt2,
	output reg [2:0] Tnew_E,
	output reg [2:0] Tnew_M,
	output reg [2:0] Tnew_W,
	output wire beq,
	output wire bne,
	output wire blez,
	output wire bgtz,
	output wire bltz,
	output wire bgez,
	output wire lb,
	output wire lbu,
	output wire lh,
	output wire lhu,
	output wire lw,
	output wire sb,
	output wire sh,
	output wire sw,
	output wire md
    );
	
	/*****译码*****/
	wire [5:0] opcode, funct;
	wire [4:0] rt;
	assign opcode = Instr[31:26];
	assign funct = Instr[5:0];
	assign rt = Instr[20:16];
	
	wire add, addu, sub, subu, sll, srl, sra, sllv, srlv, srav, andd, orr, xorr, norr, slt, sltu;
	wire addi, addiu, andi, ori, xori, lui, slti, sltiu;
	//wire lb, lbu, lh, lhu, lw, sb, sh, sw;
	//wire beq, bne, blez, bgtz, bltz, bgez;
	wire j, jal, jr, jalr;
	wire mult, multu, div, divu, mfhi, mflo, mthi, mtlo;
	
	assign add  = ((opcode == `R) && (funct == `add))  ? 1'b1 : 1'b0;
	assign addu = ((opcode == `R) && (funct == `addu)) ? 1'b1 : 1'b0;
	assign sub  = ((opcode == `R) && (funct == `sub))  ? 1'b1 : 1'b0;
	assign subu = ((opcode == `R) && (funct == `subu)) ? 1'b1 : 1'b0;
	assign sll  = ((opcode == `R) && (funct == `sll))  ? 1'b1 : 1'b0;
	assign srl  = ((opcode == `R) && (funct == `srl))  ? 1'b1 : 1'b0;
	assign sra  = ((opcode == `R) && (funct == `sra))  ? 1'b1 : 1'b0;
	assign sllv = ((opcode == `R) && (funct == `sllv)) ? 1'b1 : 1'b0;
	assign srlv = ((opcode == `R) && (funct == `srlv)) ? 1'b1 : 1'b0;
	assign srav = ((opcode == `R) && (funct == `srav)) ? 1'b1 : 1'b0;
	assign andd = ((opcode == `R) && (funct == `andd)) ? 1'b1 : 1'b0;
	assign orr  = ((opcode == `R) && (funct == `orr))  ? 1'b1 : 1'b0;
	assign xorr = ((opcode == `R) && (funct == `xorr)) ? 1'b1 : 1'b0;
	assign norr = ((opcode == `R) && (funct == `norr)) ? 1'b1 : 1'b0;
	assign slt  = ((opcode == `R) && (funct == `slt))  ? 1'b1 : 1'b0;
	assign sltu = ((opcode == `R) && (funct == `sltu)) ? 1'b1 : 1'b0;
	
	assign addi  = (opcode == `addi)  ? 1'b1 : 1'b0;
	assign addiu = (opcode == `addiu) ? 1'b1 : 1'b0;
	assign andi  = (opcode == `andi)  ? 1'b1 : 1'b0;
	assign ori   = (opcode == `ori)   ? 1'b1 : 1'b0;
	assign xori  = (opcode == `xori)  ? 1'b1 : 1'b0;
	assign lui   = (opcode == `lui)   ? 1'b1 : 1'b0;
	assign slti  = (opcode == `slti)  ? 1'b1 : 1'b0;
	assign sltiu = (opcode == `sltiu) ? 1'b1 : 1'b0;
	
	assign lb  = (opcode == `lb)  ? 1'b1 : 1'b0;
	assign lbu = (opcode == `lbu) ? 1'b1 : 1'b0;
	assign lh  = (opcode == `lh)  ? 1'b1 : 1'b0;
	assign lhu = (opcode == `lhu) ? 1'b1 : 1'b0;
	assign lw  = (opcode == `lw)  ? 1'b1 : 1'b0;
	assign sb  = (opcode == `sb)  ? 1'b1 : 1'b0;
	assign sh  = (opcode == `sh)  ? 1'b1 : 1'b0;
	assign sw  = (opcode == `sw)  ? 1'b1 : 1'b0;
	
	assign beq  = (opcode == `beq)                       ? 1'b1 : 1'b0;
	assign bne  = (opcode == `bne)                       ? 1'b1 : 1'b0;
	assign blez = (opcode == `blez)                      ? 1'b1 : 1'b0;
	assign bgtz = (opcode == `bgtz)                      ? 1'b1 : 1'b0;
	assign bltz = ((opcode == `REGIMM) && (rt == `bltz)) ? 1'b1 : 1'b0;
	assign bgez = ((opcode == `REGIMM) && (rt == `bgez)) ? 1'b1 : 1'b0;
	
	assign j    = (opcode == `j)                       ? 1'b1 : 1'b0;
	assign jal  = (opcode == `jal)                     ? 1'b1 : 1'b0;
	assign jr   = ((opcode == `R) && (funct == `jr))   ? 1'b1 : 1'b0;
	assign jalr = ((opcode == `R) && (funct == `jalr)) ? 1'b1 : 1'b0;
	
	assign mult  = ((opcode == `R) && (funct == `mult))  ? 1'b1 : 1'b0;
	assign multu = ((opcode == `R) && (funct == `multu)) ? 1'b1 : 1'b0;
	assign div   = ((opcode == `R) && (funct == `div))   ? 1'b1 : 1'b0;
	assign divu  = ((opcode == `R) && (funct == `divu))  ? 1'b1 : 1'b0;
	assign mfhi  = ((opcode == `R) && (funct == `mfhi))  ? 1'b1 : 1'b0;
	assign mflo  = ((opcode == `R) && (funct == `mflo))  ? 1'b1 : 1'b0;
	assign mthi  = ((opcode == `R) && (funct == `mthi))  ? 1'b1 : 1'b0;
	assign mtlo  = ((opcode == `R) && (funct == `mtlo))  ? 1'b1 : 1'b0;
	
	
	wire cal_r, cal_i, shift, load, store, branch, jump;
	assign cal_r = add || addu || sub || subu || sllv || srlv || srav || andd || orr || xorr || norr || slt || sltu;
	assign cal_i = addi || addiu || andi || ori || xori || lui || slti || sltiu;
	assign shift = sll || srl || sra;
	assign load = lb || lbu || lh || lhu || lw;
	assign store = sb || sh || sw;
	assign branch = beq || bne || blez || bgtz || bltz || bgez;
	assign jump = j || jal || jr || jalr;
	assign md = mult || multu || div || divu || mfhi || mflo || mthi || mtlo;
	
	/*****功能控制信号*****/
	always @(*) begin
		MPC = (branch || jump) ? `NPC :
                               `PC4;
		
		MRFWA = (cal_i || load)                          ? `rt :
		        (cal_r || shift || jalr || mfhi || mflo) ? `rd :
				  (jal)                                    ? `ra :
					                                          4'b0000;
		
		MALUA = (cal_r || cal_i || load || store) ? `rsvalue :
		        (shift)                           ? `shamt   :
				                                      4'b0000;
		
		MALUB = (cal_r || md)            ? `rtvalue :
		        (cal_i || load || store) ? `EXTimm  :
				                             4'b0000;
		
		MRFWD = (cal_r || cal_i || shift) ? `ALUout :
		        (load)                    ? `DMRD   :
				  (jal || jalr)             ? `PC8    :
				  (mfhi)                    ? `HI     :
				  (mflo)                    ? `LO     :
					                         4'b0000;
		
		DMWE = (store) ? 1'b1 : 1'b0;
		
		NPCOp = (branch)     ? `isb  :
		        (j || jal)   ? `isj  :
				  (jr || jalr) ? `isjr :
				               4'b0000;
		
		ALUOp = (add || addu || addi || addiu || load || store) ? `ADD        :
		        (sub || subu)                                   ? `SUB        :
				  (andd || andi)                                  ? `AND        :
				  (orr || ori || lui)                             ? `OR         :
				  (xorr || xori)                                  ? `XOR        :
				  (norr)                                          ? `NOR        :
				  (sll || sllv)                                   ? `LEFT       :
				  (srl || srlv)                                   ? `zero_RIGHT :
				  (sra || srav)                                   ? `sign_RIGHT :
				  (sltu || sltiu)                                 ? `zero_LESS  :
				  (slt || slti)                                   ? `sign_LESS  :
				                                                    4'b0000;
		
		EXTOp = (addi || addiu || slti || sltiu || load || store) ? `sign_ext :
		        (andi || ori || xori)                             ? `zero_ext :
				  (lui)                                             ? `high_ext :
				                                                      4'b0000;
		
		MDUwrite = (mthi) ? `whi :
		           (mtlo) ? `wlo :
				              4'b0000;
		
		MDUcal = (mult)  ? `sign_mult :
		         (multu) ? `zero_mult :
					(div)   ? `sign_div  :
					(divu)  ? `zero_div  :
					          4'b0000;
		
		start = (mult || multu || div || divu) ? 1'b1 : 1'b0;
	end
	
	/*****Tuse*****/
	always @(*) begin
		Tuse_rs0 = branch || jr || jalr;
		Tuse_rs1 = cal_r || cal_i || load || store || mult || multu || div || divu || mthi || mtlo;
		Tuse_rt0 = beq || bne;
		Tuse_rt1 = cal_r || shift || mult || multu || div || divu;
		Tuse_rt2 = store;
	end
	
	/*****Tnew*****/
	always @(*) begin
		Tnew_E = (load)                                    ? 3'd2 :
		         (cal_r || cal_i || shift || mfhi || mflo) ? 3'd1 :
					(jal || jalr)                             ? 3'd0 :
					                                            `No_result;
		Tnew_M = (Tnew_E != 3'd0) ? (Tnew_E - 3'd1) : 3'd0;
		Tnew_W = (Tnew_M != 3'd0) ? (Tnew_M - 3'd1) : 3'd0;
	end

endmodule
