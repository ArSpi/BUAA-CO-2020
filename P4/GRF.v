`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:25:08 11/14/2020 
// Design Name: 
// Module Name:    GRF 
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
module GRF(
	input clk,
	input reset,
	input WE,
	input [4:0] RA1,
	input [4:0] RA2,
	input [4:0] WA,
	input [31:0] WD,
	input [31:0] PC4,
	output [31:0] RD1,
	output [31:0] RD2
    );
	
	integer i;
	reg [31:0] GRF [31:0];
	reg [31:0] PC;
	
	initial begin
		for (i = 0; i < 32; i = i + 1)
				GRF[i] = 32'b0;
	end
	
	assign RD1 = GRF[RA1];
	assign RD2 = GRF[RA2];

	always @(*) begin
		PC = PC4 - 32'd4;
	end
	
	always @(posedge clk) begin
		if (reset == 1'b1) begin
			for (i = 0; i < 32; i = i + 1)
				GRF[i] <= 32'b0;
		end
		else begin
			if (WE == 1'b1) begin
				$display("@%h: $%d <= %h", PC, WA, WD);
				if (WA != 5'b00000) begin
					GRF[WA] <= WD;
				end
			end
		end
	end
	
endmodule
