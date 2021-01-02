`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:04:36 12/23/2020 
// Design Name: 
// Module Name:    CP0 
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
`include "define.v"
module CP0(
	input wire clk,
	input wire reset,
	//支持mfc0和mtc0
	input wire [31:0] Instr_M,
	input wire [4:0] CP0Sel,
	input wire [31:0] CP0WD,
	output wire [31:0] CP0RD,
	//interrupt & exception
	input wire BorJ,//BD
	input wire [7:2] HWInt,//IP
	input wire [6:2] ExcCode_CP0,//ExcCode
	input wire [31:0] PC_CP0,//EPC
	input wire eret_CP0,
	output reg [31:0] EPC,
	output wire IntReq,
	output wire ExcReq
    );
	/*****建模SR寄存器*****/
	wire [31:0] SR;
	reg [7:2] IM;
	reg EXL;
	reg IE;
	assign SR = {16'b0, IM, 8'b0, EXL, IE};
	/*****建模CAUSE寄存器*****/
	wire [31:0] CAUSE;
	reg BD;
	reg [7:2] IP;
	reg [6:2] ExcCode;
	assign CAUSE = {BD, 15'b0, IP, 3'b0, ExcCode, 2'b0};
	/*****建模EPC寄存器*****/
	//reg [31:0] EPC;
	/*****建模PrID寄存器*****/
	reg [31:0] PrID;
	
	initial begin
		EPC = 32'b0;
		IM = 6'b0;
		EXL = 1'b0;
		IE = 1'b0;
		BD = 1'b0;
		IP = 6'b0;
		ExcCode = 5'b0;
		PrID = 32'h12345678;
	end
	
	wire CP0WE;
	Decoder code_CP0(.Instr(Instr_M), .CP0WE(CP0WE));
	assign IntReq = ((HWInt & IM) != 6'b0) & IE & !EXL;
	assign ExcReq = (!IntReq) && (ExcCode_CP0 != 5'b0);
	
	always @(posedge clk) begin
		if (reset) begin
			EPC = 32'b0;
			IM = 6'b0;
			EXL = 1'b0;
			IE = 1'b0;
			BD = 1'b0;
			IP = 6'b0;
			ExcCode = 5'b0;
			PrID = 32'h12345678;
		end
		else begin
			IP <= HWInt;
			if (IntReq) begin
				EPC <= (BorJ) ? {PC_CP0[31:2], 2'b00} - 32'd4 : {PC_CP0[31:2], 2'b00};
				EXL <= 1'b1;
				ExcCode <= 5'b0;
				BD <= BorJ;
			end
			else if (ExcReq) begin
				EPC <= (BorJ) ? {PC_CP0[31:2], 2'b00} - 32'd4 : {PC_CP0[31:2], 2'b00};
				EXL <= 1'b1;
				ExcCode <= ExcCode_CP0;
				BD <= BorJ;
			end
			else if (eret_CP0) begin
				EXL <= 1'b0;
			end
			else begin
				if (CP0WE) begin
					case(CP0Sel)
						`SR:{IM, EXL, IE} <= {CP0WD[15:10], CP0WD[1:0]};
						`EPCreg:EPC <= CP0WD;
						default:PrID <= 32'h12345678;
					endcase
				end
			end
		end
	end
	
	assign CP0RD = (CP0Sel == `SR)     ? SR :
	               (CP0Sel == `CAUSE)  ? CAUSE :
						(CP0Sel == `EPCreg) ? EPC :
						(CP0Sel == `PrID)   ? PrID :
						                      32'hffffffff;
	
endmodule
