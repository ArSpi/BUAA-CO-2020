`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:21:41 11/15/2020 
// Design Name: 
// Module Name:    IFU 
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
`define npc_normal 2'b00
`define npc_beq 2'b01
`define npc_jal 2'b10
`define npc_jr 2'b11

module IFU(
	input clk,
	input reset,
	input zero,
	input [1:0] NPCOp,
	input [31:0] rsvalue,
	output [31:0] Instr,
	output [31:0] PC4
    );
	
	reg [31:0] PC;
	reg [31:0] IM [1023:0];
	
	initial begin
		PC <= 32'h00003000;
		$readmemh("code.txt", IM);
	end
	
	assign Instr = IM[PC[11:2]];
	assign PC4 = PC + 32'd4;
	
	always @(posedge clk) begin
		if (reset == 1'b1) begin
			PC <= 32'h00003000;
		end
		else begin
			case(NPCOp)
			`npc_normal:begin
					PC <= PC + 32'd4;
				end
			`npc_beq:begin
					if (zero == 1'b1) begin
						PC <= PC + 32'd4 + {{14{Instr[15]}}, Instr[15:0], 2'b00};
					end
					else begin
						PC <= PC +32'd4;
					end
				end
			`npc_jal:begin
					PC <= {PC[31:28], Instr[25:0], 2'b00};
				end
			`npc_jr:begin
					PC <= rsvalue;
				end
			default:begin
					PC <= 32'h12345678;
				end
			endcase
		end
	end

endmodule
