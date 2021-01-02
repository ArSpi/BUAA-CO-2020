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
	reg [31:0] IM [1023:0];
	integer i;
	
	initial begin
		for (i = 0 ; i < 1024 ; i = i + 1)
				IM[i] = 32'b0;
		$readmemh("code.txt", IM);
	end
	
	assign Instr = IM[PC[11:2]];

endmodule
