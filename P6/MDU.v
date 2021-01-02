`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:32:35 12/09/2020 
// Design Name: 
// Module Name:    MDU 
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
module MDU(
	input wire clk,
	input wire reset,
	input wire [31:0] Instr_E,
	input wire [31:0] rsvalue,
	input wire [31:0] rtvalue,
	output reg [31:0] HI,
	output reg [31:0] LO,
	output wire start,
	output reg busy
    );
	integer mult_cycle, div_cycle;
	reg [31:0] HIpre, LOpre;
	wire [3:0] MDUwrite, MDUcal;
	Decoder code_MDU(.Instr(Instr_E), .MDUwrite(MDUwrite), .MDUcal(MDUcal), .start(start));
	
	wire [31:0] D1, D2;
	assign D1 = rsvalue;
	assign D2 = rtvalue;
	
	initial begin
		HI = 32'b0;
		LO = 32'b0;
		busy = 1'b0;
		mult_cycle = 5;
		div_cycle = 10;
	end
	
	always @(posedge clk) begin
		if (reset) begin
			HI <= 32'b0;
			LO <= 32'b0;
			busy <= 1'b0;
			mult_cycle <= 5;
			div_cycle <= 10;
		end
		else begin
			//HILO写入相关
			if (MDUwrite == `whi) begin
				HI <= D1;
			end
			else if (MDUwrite == `wlo) begin
				LO <= D1;
			end
			//乘除计算相关
			if (start) begin
				if (MDUcal == `sign_mult) begin
					{HIpre, LOpre} <= $signed(D1) * $signed(D2);
					busy <= 1'b1;
					mult_cycle <= mult_cycle - 1;
				end
				else if (MDUcal == `zero_mult) begin
					{HIpre, LOpre} <= D1 * D2;
					busy <= 1'b1;
					mult_cycle <= mult_cycle - 1;
				end
				else if (MDUcal == `sign_div) begin
					HIpre <= $signed(D1) % $signed(D2);
					LOpre <= $signed(D1) / $signed(D2);
					busy <= 1'b1;
					div_cycle <= div_cycle - 1;
				end
				else if (MDUcal == `zero_div) begin
					HIpre <= D1 % D2;
					LOpre <= D1 / D2;
					busy <= 1'b1;
					div_cycle <= div_cycle - 1;
				end
			end
			
			if (mult_cycle == 0) begin
				HI <= HIpre;
				LO <= LOpre;
				busy <= 1'b0;
				mult_cycle <= 5;
			end
			else if (mult_cycle != 5) begin
				busy <= 1'b1;
				mult_cycle <= mult_cycle - 1;
			end
			
			if (div_cycle == 0) begin
				HI <= HIpre;
				LO <= LOpre;
				busy <= 1'b0;
				div_cycle <= 10;
			end
			else if (div_cycle != 10) begin
				busy <= 1'b1;
				div_cycle <= div_cycle - 1;
			end
		end
	end
	
endmodule
