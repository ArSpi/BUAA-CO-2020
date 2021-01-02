`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:09:46 11/15/2020 
// Design Name: 
// Module Name:    Controller 
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
module Controller(
	input [31:0] Instr,
	output reg [1:0] MUX1,
	output reg MUX2,
	output reg [1:0] MUX3,
	output reg GRFWE,
	output reg DMWE,
	output reg DMRE,
	output reg [1:0] NPCOp,
	output reg [1:0] ALUOp,
	output reg [1:0] EXTOp
    );
	
	wire [5:0] opcode, funct;
	assign opcode = Instr[31:26];
	assign funct = Instr[5:0];
	
	always @(*) begin
		case(opcode)
		`R:begin
				case(funct)
				`addu:begin
						MUX1 = 2'b01;
						MUX2 = 1'b0;
						MUX3 = 1'b0;
						GRFWE = 1'b1;
						DMWE = 1'b0;
						DMRE = 1'b0;
						NPCOp = 2'b00;
						ALUOp = 2'b00;
						EXTOp = 2'b00;//EXTOp
					end
				`subu:begin
						MUX1 = 2'b01;
						MUX2 = 1'b0;
						MUX3 = 1'b0;
						GRFWE = 1'b1;
						DMWE = 1'b0;
						DMRE = 1'b0;
						NPCOp = 2'b00;
						ALUOp = 2'b01;
						EXTOp = 2'b00;//EXTOp
					end
				`nop:begin
						MUX1 = 2'b00;//MUX1
						MUX2 = 1'b0;//MUX2
						MUX3 = 2'b00;//MUX3
						GRFWE = 1'b0;
						DMWE = 1'b0;
						DMRE = 1'b0;
						NPCOp = 2'b00;
						ALUOp = 2'b00;//ALUOp
						EXTOp = 2'b00;//EXTOp
					end
				`jr:begin
						MUX1 = 2'b00;//MUX1
						MUX2 = 1'b0;//MUX2
						MUX3 = 2'b00;//MUX3
						GRFWE = 1'b0;//GRFWE
						DMWE = 1'b0;//DMWE
						DMRE = 1'b0;//DMRE
						NPCOp = 2'b11;
						ALUOp = 2'b00;//ALUOp
						EXTOp = 2'b00;//EXTOp
					end
				default:begin
						MUX1 = 2'b00;
						MUX2 = 1'b0;
						MUX3 = 1'b0;
						GRFWE = 1'b0;
						DMWE = 1'b0;
						DMRE = 1'b0;
						NPCOp = 2'b00;
						ALUOp = 2'b00;
						EXTOp = 2'b00;
					end
				endcase
			end
		`ori:begin
				MUX1 = 2'b00;
				MUX2 = 1'b1;
				MUX3 = 1'b0;
				GRFWE = 1'b1;
				DMWE = 1'b0;
				DMRE = 1'b0;
				NPCOp = 2'b00;
				ALUOp = 2'b10;
				EXTOp = 2'b01;
			end
		`lw:begin
				MUX1 = 2'b00;
				MUX2 = 1'b1;
				MUX3 = 1'b1;
				GRFWE = 1'b1;
				DMWE = 1'b0;
				DMRE = 1'b1;
				NPCOp = 2'b00;
				ALUOp = 2'b00;
				EXTOp = 2'b00;
			end
		`sw:begin
				MUX1 = 2'b00;//MUX1
				MUX2 = 1'b1;
				MUX3 = 2'b00;//MUX3
				GRFWE = 1'b0;
				DMWE = 1'b1;
				DMRE = 1'b0;
				NPCOp = 2'b00;
				ALUOp = 2'b00;
				EXTOp = 2'b00;
			end
		`beq:begin
				MUX1 = 2'b00;//MUX1
				MUX2 = 1'b0;
				MUX3 = 2'b00;//MUX3
				GRFWE = 1'b0;
				DMWE = 1'b0;
				DMRE = 1'b0;
				NPCOp = 2'b01;
				ALUOp = 2'b11;
				EXTOp = 2'b00;//EXTOp
			end
		`lui:begin
				MUX1 = 2'b00;
				MUX2 = 1'b1;
				MUX3 = 1'b0;
				GRFWE = 1'b1;
				DMWE = 1'b0;
				DMRE = 1'b0;
				NPCOp = 2'b00;
				ALUOp = 2'b10;
				EXTOp = 2'b10;
			end
		`jal:begin
				MUX1 = 2'b10;
				MUX2 = 1'b0;//MUX2
				MUX3 = 2'b10;
				GRFWE = 1'b1;
				DMWE = 1'b0;//DMWE
				DMRE = 1'b0;//DMRE
				NPCOp = 2'b10;
				ALUOp = 2'b00;//ALUOp
				EXTOp = 2'b00;//EXTOp
			end
		default:begin
				MUX1 = 2'b00;
				MUX2 = 1'b0;
				MUX3 = 1'b0;
				GRFWE = 1'b0;
				DMWE = 1'b0;
				DMRE = 1'b0;
				NPCOp = 2'b00;
				ALUOp = 2'b00;
				EXTOp = 2'b00;
			end
		endcase
	end


endmodule
