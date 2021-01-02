`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:45:44 11/29/2020 
// Design Name: 
// Module Name:    PC 
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
module PC(
	input wire clk,
	input wire reset,
	input wire [31:0] NextPC,
	input wire En_PC,
	input wire stall_md,
	output reg [31:0] PC
    );
	
	initial begin
		PC = 32'h00003000;
	end
	
	always @(posedge clk) begin
		if (reset == 1'b1) begin
			PC <= 32'h00003000;
		end
		else begin
			if (En_PC && !stall_md) begin
				PC <= NextPC;
			end
		end
	end

endmodule
