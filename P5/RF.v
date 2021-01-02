`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:03:30 11/29/2020 
// Design Name: 
// Module Name:    RF 
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
module RF(
	input wire clk,
	input wire reset,
	input wire [31:0] Instr_W,
	input wire [4:0] RA1,
	input wire [4:0] RA2,
	input wire [4:0] WA,
	input wire [31:0] WD,
	input wire [31:0] PC_W,
	output wire [31:0] RD1,
	output wire [31:0] RD2
    );
	reg [31:0] RF [31:0];
	integer i;
	
	initial begin
		for (i = 0; i < 32; i = i + 1)
			RF[i] = 32'b0;
	end
	
	wire WE;
	Decoder code_RF(.Instr(Instr_W), .RFWE(WE));
	
	assign RD1 = RF[RA1];
	assign RD2 = RF[RA2];
	
	always @(posedge clk) begin
		if (reset == 1'b1) begin
			for (i = 0; i < 32; i = i + 1)
				RF[i] <= 32'b0;
		end
		else begin
			if (WE == 1'b1) begin
				$display("%d@%h: $%d <= %h", $time, PC_W, WA, WD);
				if (WA != 5'b00000) begin
					RF[WA] <= WD;
				end
			end
		end
	end
	
	
endmodule
