`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:15:57 11/29/2020 
// Design Name: 
// Module Name:    MUX 
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
/**********功能型多路选择器**********/
module MPC(
	input wire [31:0] Instr_D,
	input wire [31:0] NPC,
	input wire [31:0] PC4,
	output reg [31:0] NextPC
    );
	wire [3:0] MPC;
	Decoder code_MPC(.Instr(Instr_D), .MPC(MPC));
	
	always @(*) begin
		case(MPC)
			`NPC:NextPC = NPC;
			`PC4:NextPC = PC4;
			default:NextPC = 32'h00003000;
		endcase
	end

endmodule

module MRFWA(
	input wire [31:0] Instr_D,
	output reg [4:0] RFWA
    );
	wire [3:0] MRFWA;
	Decoder code_MRFWA(.Instr(Instr_D), .MRFWA(MRFWA));
	
	wire [4:0] rt,rd;
	assign rt = Instr_D[20:16];
	assign rd = Instr_D[15:11];
	always @(*) begin
		case(MRFWA)
			`rt:RFWA = rt;
			`rd:RFWA = rd;
			`ra:RFWA = 5'd31;
			default:RFWA = 5'b0;
		endcase
	end

endmodule

module MALUB(
	input wire [31:0] Instr_E,
	input wire [31:0] real_ALUB,
	input wire [31:0] EXTimm_E,
	output reg [31:0] ALUB
    );
	wire [3:0] MALUB;
	Decoder code_MALUB(.Instr(Instr_E), .MALUB(MALUB));
	
	always @(*) begin
		case(MALUB)
			`real_ALUB:ALUB = real_ALUB;
			`EXTimm:ALUB = EXTimm_E;
			default:ALUB = 32'b0;
		endcase
	end

endmodule

module MRFWD(
	input wire [31:0] Instr_W,
	input wire [31:0] ALUout_W,
	input wire [31:0] DMRD_W,
	input wire [31:0] PC_W,
	output reg [31:0] RFWD
    );
	wire [3:0] MRFWD;
	Decoder code_MRFWD(.Instr(Instr_W), .MRFWD(MRFWD));
	
	always @(*) begin
		case(MRFWD)
			`ALUout:RFWD = ALUout_W;
			`DMRD:RFWD = DMRD_W;
			`PC8:RFWD = PC_W + 32'd8;
			default:RFWD = 32'b0;
		endcase
	end

endmodule
/**********转发多路选择器**********/
module MFRD1D(
	input wire [31:0] PC_E,
	input wire [31:0] PC_M,
	input wire [31:0] PC_W,
	input wire [31:0] ALUout_M,
	input wire [31:0] ALUout_W,
	input wire [31:0] DMRD_W,
	input wire [31:0] RFRD1,
	input wire [3:0] MFRD1D,
	output reg [31:0] real_RFRD1
	 );
	always @(*) begin
		case(MFRD1D)
			`EtoD_PC8: real_RFRD1 = PC_E + 32'd8;
			`MtoD_PC8: real_RFRD1 = PC_M + 32'd8;
			`MtoD_ALU: real_RFRD1 = ALUout_M;
			`WtoD_PC8: real_RFRD1 = PC_W + 32'd8;
			`WtoD_ALU: real_RFRD1 = ALUout_W;
			`WtoD_DM : real_RFRD1 = DMRD_W;
			default  : real_RFRD1 = RFRD1;
		endcase
	end

endmodule

module MFRD2D(
	input wire [31:0] PC_E,
	input wire [31:0] PC_M,
	input wire [31:0] PC_W,
	input wire [31:0] ALUout_M,
	input wire [31:0] ALUout_W,
	input wire [31:0] DMRD_W,
	input wire [31:0] RFRD2,
	input wire [3:0] MFRD2D,
	output reg [31:0] real_RFRD2
	 );
	always @(*) begin
		case(MFRD2D)
			`EtoD_PC8: real_RFRD2 = PC_E + 32'd8;
			`MtoD_PC8: real_RFRD2 = PC_M + 32'd8;
			`MtoD_ALU: real_RFRD2 = ALUout_M;
			`WtoD_PC8: real_RFRD2 = PC_W + 32'd8;
			`WtoD_ALU: real_RFRD2 = ALUout_W;
			`WtoD_DM : real_RFRD2 = DMRD_W;
			default  : real_RFRD2 = RFRD2;
		endcase
	end

endmodule

module MFALUAE(
	input wire [31:0] PC_M,
	input wire [31:0] PC_W,
	input wire [31:0] ALUout_M,
	input wire [31:0] ALUout_W,
	input wire [31:0] DMRD_W,
	input wire [31:0] RFRD1_E,
	input wire [3:0] MFALUAE,
	output reg [31:0] real_ALUA
	 );
	always @(*) begin
		case(MFALUAE)
			`MtoE_PC8: real_ALUA = PC_M + 32'd8;
			`MtoE_ALU: real_ALUA = ALUout_M;
			`WtoE_PC8: real_ALUA = PC_W + 32'd8;
			`WtoE_ALU: real_ALUA = ALUout_W;
			`WtoE_DM : real_ALUA = DMRD_W;
			default  : real_ALUA = RFRD1_E;
		endcase
	end
	
endmodule

module MFALUBE(
	input wire [31:0] PC_M,
	input wire [31:0] PC_W,
	input wire [31:0] ALUout_M,
	input wire [31:0] ALUout_W,
	input wire [31:0] DMRD_W,
	input wire [31:0] RFRD2_E,
	input wire [3:0] MFALUBE,
	output reg [31:0] real_ALUB
	 );
	always @(*) begin
		case(MFALUBE)
			`MtoE_PC8: real_ALUB = PC_M + 32'd8;
			`MtoE_ALU: real_ALUB = ALUout_M;
			`WtoE_PC8: real_ALUB = PC_W + 32'd8;
			`WtoE_ALU: real_ALUB = ALUout_W;
			`WtoE_DM : real_ALUB = DMRD_W;
			default  : real_ALUB = RFRD2_E;
		endcase
	end

endmodule

module MFWDM(
	input wire [31:0] PC_W,
	input wire [31:0] ALUout_W,
	input wire [31:0] DMRD_W,
	input wire [31:0] RFRD2_M,
	input wire [3:0] MFWDM,
	output reg [31:0] real_DMWD
	 );
	always @(*) begin
		case(MFWDM)
			`WtoM_PC8: real_DMWD = PC_W + 32'd8;
			`WtoM_ALU: real_DMWD = ALUout_W;
			`WtoM_DM : real_DMWD = DMRD_W;
			default  : real_DMWD = RFRD2_M;
		endcase
	end

endmodule