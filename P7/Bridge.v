`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:05:32 12/16/2020 
// Design Name: 
// Module Name:    Bridge 
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
module Bridge(
	//Bridge-CPU
	input wire [31:0] PrAddr,
	input wire [31:0] PrWD,
	input wire PrWE,
	output wire [31:0] PrRD,
	//Bridge-Timer0
	input wire [31:0] TC0RD,
	output wire TC0_WE,
	//Bridge-Timer1
	input wire [31:0] TC1RD,
	output wire TC1_WE,
	//Bridge-Devices
	output wire [31:2] DevAddr,
	output wire [31:0] DevWD
    );
	wire hitTC0, hitTC1;
	assign hitTC0 = (32'h7f00 <= PrAddr) && (PrAddr <= 32'h7f0b);
	assign hitTC1 = (32'h7f10 <= PrAddr) && (PrAddr <= 32'h7f1b);
	
	assign PrRD = hitTC0 ? TC0RD :
	              hitTC1 ? TC1RD :
					           32'hffffffff;
	
	assign TC0_WE = hitTC0 & PrWE;
	assign TC1_WE = hitTC1 & PrWE;
	assign DevAddr = PrAddr[31:2];
	assign DevWD = PrWD;
	
endmodule
