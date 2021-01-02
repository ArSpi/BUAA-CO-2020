`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:22:20 11/15/2020 
// Design Name: 
// Module Name:    DM 
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
module DM(
	input clk,
	input reset,
	input [31:0] Addr,
	input [31:0] WD,
	input WE,
	input RE,
	input [31:0] PC4,
	output reg [31:0] RD
    );
	
	integer i;
	reg [31:0] DM [1023:0];
	reg [31:0] PC;
	
	initial begin
		for (i = 0; i < 1024; i = i + 1)
			DM[i] = 32'b0;
	end
	
	always @(*) begin
		PC = PC4 - 32'd4;
		
		if (RE == 1'b1) begin
				RD <= DM[Addr[11:2]];
		end
	end
	
	always @(posedge clk) begin
		if (reset == 1'b1) begin
			for (i = 0; i < 1024; i = i + 1)
				DM[i] <= 32'b0;
		end
		else begin
			if (WE == 1'b1) begin
				DM[Addr[11:2]] <= WD;
				$display("@%h: *%h <= %h", PC, Addr, WD);
			end
		end
	end

endmodule
