`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:37:13 10/27/2020 
// Design Name: 
// Module Name:    gray 
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
module gray(
    input Clk,
    input Reset,
    input En,
    output reg [2:0] Output,
    output reg Overflow
    );
	parameter S0 = 3'b000;
	parameter S1 = 3'b001;
	parameter S2 = 3'b011;
	parameter S3 = 3'b010;
	parameter S4 = 3'b110;
	parameter S5 = 3'b111;
	parameter S6 = 3'b101;
	parameter S7 = 3'b100;
	
	initial begin
		Output = 3'b000;
		Overflow = 1'b0;
	end
	
	always@(posedge Clk) begin
		if (Reset == 1'b1) begin
			Output <= S0;
			Overflow <= 1'b0;
		end
		else begin
			if (En == 1'b1) begin
				case(Output)
				S0:begin
						Output <= S1;
					end
				S1:begin
						Output <= S2;
					end
				S2:begin
						Output <= S3;
					end
				S3:begin
						Output <= S4;
					end
				S4:begin
						Output <= S5;
					end
				S5:begin
						Output <= S6;
					end
				S6:begin
						Output <= S7;
					end
				S7:begin
						Output <= S0;
						Overflow <= 1'b1;
					end
				endcase
			end
		end
	end

endmodule
