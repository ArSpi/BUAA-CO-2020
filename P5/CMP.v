`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:58:23 11/29/2020 
// Design Name: 
// Module Name:    CMP 
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
module CMP(
	input wire [31:0] real_RFRD1,
	input wire [31:0] real_RFRD2,
	output wire zero
    );
	assign zero = (real_RFRD1 == real_RFRD2) ? 1'b1 : 1'b0;

endmodule
