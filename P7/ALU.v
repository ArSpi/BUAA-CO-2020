`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:28:10 11/29/2020 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
	input wire [31:0] Instr_E,
	input wire [31:0] rsvalue,
	input wire [31:0] rtvalue,
	input wire [31:0] EXTimm,
	output reg [31:0] ALUout,
	output wire AdEL_E,
	output wire AdEs_E,
	output wire Ov_E
    );
	wire [3:0] ALUOp, MALUA, MALUB;
	wire add, addi, sub;
	wire lb, lbu, lh, lhu, lw;
	wire sb, sh, sw;
	Decoder code_ALU(.Instr(Instr_E), .ALUOp(ALUOp), .MALUA(MALUA), .MALUB(MALUB),
	                 .add(add), .addi(addi), .sub(sub),
						  .lb(lb), .lbu(lbu), .lh(lh), .lhu(lhu), .lw(lw),
						  .sb(sb), .sh(sh), .sw(sw));
	
	wire [31:0] shamt;
	assign shamt = {27'b0, Instr_E[10:6]};
	
	reg [31:0] A, B;
	always @(*) begin
		case(MALUA)
			`rsvalue:A = rsvalue;
			`shamt:A = shamt;
			default:A = 32'b0;
		endcase
	
		case(MALUB)
			`rtvalue:B = rtvalue;
			`EXTimm:B = EXTimm;
			default:B = 32'b0;
		endcase
	
		case(ALUOp)
			`ADD:ALUout = A + B;
			`SUB:ALUout = A - B;
			`AND:ALUout = A & B;
			`OR:ALUout = A | B;
			`XOR:ALUout = A ^ B;
			`NOR:ALUout = ~(A | B);
			`LEFT:ALUout = B << A[4:0];
			`zero_RIGHT:ALUout = B >> A[4:0];
			`sign_RIGHT:ALUout = $signed(B) >>> A[4:0];
			`zero_LESS:ALUout = A < B;
			`sign_LESS:ALUout = $signed(A) < $signed(B);
			default:ALUout = 32'b0;
		endcase
	end
	
	wire [32:0] temp;
	wire Overflow;
	assign temp = (ALUOp == `ADD) ? {A[31], A} + {B[31], B} :
	              (ALUOp == `SUB) ? {A[31], A} - {B[31], B} :
					                    33'b0;
	assign Overflow = temp[32] ^ temp[31];
	assign AdEL_E = ((lb || lbu || lh || lhu || lw) && (Overflow)) ? 1'b1 : 1'b0;
	assign AdEs_E = ((sb || sh || sw) && (Overflow)) ? 1'b1 : 1'b0;
	assign Ov_E = ((add || addi || sub) && (Overflow)) ? 1'b1 : 1'b0;
	
endmodule
