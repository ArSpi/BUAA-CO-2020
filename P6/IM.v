`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:52:43 11/29/2020 
// Design Name: 
// Module Name:    IM 
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
module IM(
	input wire [31:0] PC,
	output wire [31:0] Instr
    );
	reg [31:0] IM [4095:0];
	integer i;
	
	initial begin
		for (i = 0 ; i < 4096 ; i = i + 1)
				IM[i] = 32'b0;
		$readmemh("code.txt", IM);
	end
	
	wire [31:0] addr;
	assign addr = PC - 32'h00003000;
	assign Instr = IM[addr[13:2]];

endmodule
