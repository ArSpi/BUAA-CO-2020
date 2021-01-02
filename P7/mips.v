`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:28:45 12/16/2020 
// Design Name: 
// Module Name:    mips 
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
module mips(
	input wire clk,
	input wire reset,
	input wire interrupt,
	output wire [31:0] addr//这里addr指的是宏观指令，什么是宏观指令？
    );
	wire [31:0] macro_pc;
	assign addr = macro_pc;
	
	wire [31:0] PrAddr, PrWD, PrRD, TC0RD, TC1RD, DevWD;
	wire [31:2] DevAddr;
	wire PrWE, TC0_WE, TC1_WE;
	
	wire [7:2] HWInt;
	assign HWInt[7:5] = 3'b000;
	assign HWInt[4] = interrupt;
	
	CPU CPU(
		.clk(clk),
		.reset(reset),
		//P7 Bridge
		.PrRD(PrRD),
		.PrAddr(PrAddr),
		.PrWD(PrWD),
		.PrWE(PrWE),
		.HWInt(HWInt),
		.macro_pc(macro_pc)
	);
	
	Bridge Bridge(
		.PrAddr(PrAddr),
		.PrWD(PrWD),
		.PrWE(PrWE),
		.PrRD(PrRD),
		.TC0RD(TC0RD),
		.TC0_WE(TC0_WE),
		.TC1RD(TC1RD),
		.TC1_WE(TC1_WE),
		.DevAddr(DevAddr),
		.DevWD(DevWD)
	);
	
	TC Timer0(
		.clk(clk),
		.reset(reset),
		.Addr(DevAddr),
		.WE(TC0_WE),
		.Din(DevWD),
		.Dout(TC0RD),
		.IRQ(HWInt[2])
	);
	
	TC Timer1(
		.clk(clk),
		.reset(reset),
		.Addr(DevAddr),
		.WE(TC1_WE),
		.Din(DevWD),
		.Dout(TC1RD),
		.IRQ(HWInt[3])
	);
	
endmodule
