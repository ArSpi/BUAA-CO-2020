`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:33:59 11/29/2020 
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
`default_nettype none
module DM(
	input wire clk,
	input wire reset,
	input wire [31:0] Instr_M,
	input wire [31:0] Addr,
	input wire [31:0] WD,
	input wire [31:0] PC,
	output reg [31:0] RD
    );
	reg [31:0] DM [1023:0];
	integer i;
	
	initial begin
		for (i = 0; i < 1024; i = i + 1)
			DM[i] = 32'b0;
	end
	
	wire WE;
	Decoder code_DM(.Instr(Instr_M), .DMWE(WE));
	
	always @(*) begin
		RD = DM[Addr[11:2]];
	end
	
	always @(posedge clk) begin
		if (reset == 1'b1) begin
			for (i = 0; i < 1024; i = i + 1)
				DM[i] <= 32'b0;
		end
		else begin
			if (WE == 1'b1) begin
				DM[Addr[11:2]] <= WD;
				$display("%d@%h: *%h <= %h", $time, PC, Addr, WD);
			end
		end
	end

endmodule
