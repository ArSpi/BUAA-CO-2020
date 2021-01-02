`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:54:07 11/29/2020 
// Design Name: 
// Module Name:    NPC 
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
module NPC(
	input wire [31:0] Instr_D,
	input wire [31:0] PC_D,
	input wire [31:0] real_RFRD1,
	input wire zero,
	output reg [31:0] NPC
    );
	wire [3:0] NPCOp;
	Decoder code_NPC(.Instr(Instr_D), .NPCOp(NPCOp));
	
	always @(*) begin
		case(NPCOp)
			`isb:begin
					if (zero == 1'b1) begin
						NPC = PC_D + 32'd4 + {{14{Instr_D[15]}}, Instr_D[15:0], 2'b00};
					end
					else begin
						NPC = PC_D + 32'd8;
					end
				end
			`isj:begin
					NPC = {PC_D[31:28], Instr_D[25:0], 2'b00};
				end
			`isjr:begin
					NPC = real_RFRD1;
				end
			default:NPC = 32'h00003000;
		endcase
	end

endmodule
