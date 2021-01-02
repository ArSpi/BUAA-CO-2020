`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:17:49 10/28/2020 
// Design Name: 
// Module Name:    BlockChecker 
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
module BlockChecker(
    input clk,
    input reset,
    input [7:0] in,
    output result
    );
	parameter S0 = 4'b0000;
	parameter S1 = 4'b0001;
	parameter S2 = 4'b0010;
	parameter S3 = 4'b0011;
	parameter S4 = 4'b0100;
	parameter S5 = 4'b0101;
	parameter S6 = 4'b0110;
	parameter S7 = 4'b0111;
	parameter S8 = 4'b1000;
	parameter S9 = 4'b1001;
	parameter S10 = 4'b1010;
	parameter S11 = 4'b1011;
	
	reg [3:0] status = 4'b0000;
	reg [31:0] BEGIN = 32'b0;
	reg [31:0] END = 32'b0;
	reg sign = 1'b0;
	reg isend = 1'b0;
	reg signal = 1'b0;
	
//	always @(*) begin
//		if (END > BEGIN) begin
//			egrtb = 1'b1;
//		end
//		else begin
//			egrtb = 1'b0;
//		end
//
//	/	if (reset == 1'b1) begin
//			sign = 1'b0;
//		end
//		else begin
//			if (egrtb == 1'b1) begin
//				sign = 1'b1;
//			end
//	/		if ((in != " ") && (status == S10)) begin
//				sign = 1'b0;
//			end
//		end
//	end
	always @(*) begin
		if (reset == 1'b1) begin
			signal = 1'b0;
		end
		else begin
			if ((sign == 1'b1) || (isend == 1'b1)) begin
				signal = 1'b1;
			end
			else begin
				signal = 1'b0;
			end
		end
	end
	
	assign result = ((BEGIN == END) && (signal == 1'b0)) ? 1'b1 : 1'b0;
	
	always @(posedge clk or posedge reset) begin
		if (reset == 1'b1) begin
			status <= S0;
			BEGIN <= 32'b0;
			END <= 32'b0;
			sign <= 1'b0;
			isend <= 1'b0;
		end
		else begin
			case(status)
			S0:begin
					if ((in == "b") || (in == "B")) begin
						status <= S1;
					end
					else if ((in == "e") || (in == "E")) begin
						status <= S6;
					end
					else if (in == " ") begin
						status <= S0;
					end
					else begin
						status <= S11;
					end
				end
			S1:begin
					if ((in == "e") || (in == "E")) begin
						status <= S2;
					end
					else if (in == " ") begin
						status <= S0;
					end
					else begin
						status <= S11;
					end
				end
			S2:begin
					if ((in == "g") || (in == "G")) begin
						status <= S3;
					end
					else if (in == " ") begin
						status <= S0;
					end
					else begin
						status <= S11;
					end
				end
			S3:begin
					if ((in == "i") || (in == "I")) begin
						status <= S4;
					end
					else if (in == " ") begin
						status <= S0;
					end
					else begin
						status <= S11;
					end
				end
			S4:begin
					if ((in == "n") || (in == "N")) begin
						status <= S5;
						BEGIN <= BEGIN + 32'b1;
					end
					else if (in == " ") begin
						status <= S0;
					end
					else begin
						status <= S11;
					end
				end
			S5:begin
					if (in == " ") begin
						status <= S0;
					end
					else begin
						status <= S9;
						BEGIN <= BEGIN - 32'b1;
					end
				end
			S6:begin
					if ((in == "n") || (in == "N")) begin
						status <= S7;
					end
					else if (in == " ") begin
						status <= S0;
					end
					else begin
						status <= S11;
					end
				end
			S7:begin
					if ((in == "d") || (in == "D")) begin
						status <= S8;
						END <= END + 32'b1;
						if (BEGIN == END) begin
							sign <= 1'b1;
						end
					end
					else if (in == " ") begin
						status <= S0;
					end
					else begin
						status <= S11;
					end
				end
			S8:begin
					if (in == " ") begin
						status <= S0;
						if (END == BEGIN + 32'b1) begin
							isend <= 1'b1;
						end
					end
					else begin
						status <= S10;
						END <= END - 32'b1;
						if (END == BEGIN + 32'b1) begin
							sign <= 1'b0;
						end
					end
				end
			S9:begin
					if (in == " ") begin
						status <= S0;
					end
					else begin
						status <= S9;
					end
				end
			S10:begin
					if (in == " ") begin
						status <= S0;
					end
					else begin
						status <= S10;
					end
				end
			S11:begin
					if (in == " ") begin
						status <= S0;
					end
					else begin
						status <= S11;
					end
				end
			endcase
		end
	end

endmodule



//always块之间是并行执行的，即使两个块里都是组合逻辑，所以想让组合逻辑一条条执行，就要把他们放在一个always块里