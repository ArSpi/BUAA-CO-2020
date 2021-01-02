`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:41:10 10/27/2020 
// Design Name: 
// Module Name:    string 
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
module string(
    input clk,
    input clr,
    input [7:0] in,
    output out
    );
	parameter S0 = 2'b00;
	parameter S1 = 2'b01;
	parameter S2 = 2'b10;
	parameter S3 = 2'b11;
	
	reg [1:0] status = S0; 
	
	always@(posedge clk or posedge clr) begin
		if (clr == 1'b1) begin
			status <= S0;
		end
		else begin
			case(status)
			S0:begin
					if ((in >= 8'h30) && (in <= 8'h39)) begin
						status <= S1;
					end
					else if ((in == "+") || (in == "*")) begin
						status <= S3;
					end
					else begin
						status <= S3;
					end
				end
			S1:begin
					if ((in >= 8'h30) && (in <= 8'h39)) begin
						status <= S3;
					end
					else if ((in == "+") || (in == "*")) begin
						status <= S2;
					end
					else begin
						status <= S3;
					end
				end
			S2:begin
					if ((in >= 8'h30) && (in <= 8'h39)) begin
						status <= S1;
					end
					else if ((in == "+") || (in == "*")) begin
						status <= S3;
					end
					else begin
						status <= S3;
					end
				end
			S3:begin
					if ((in >= 8'h30) && (in <= 8'h39)) begin
						status <= S3;
					end
					else if ((in == "+") || (in == "*")) begin
						status <= S3;
					end
					else begin
						status <= S3;
					end
				end
			endcase
		end
	end
	
	assign out = (status == S1) ? 1'b1 : 1'b0;

endmodule
