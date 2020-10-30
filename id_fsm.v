`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:18:10 10/03/2020 
// Design Name: 
// Module Name:    id_fsm 
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
`define S0 2'b00
`define S1 2'b01
`define S2 2'b10
`define S3 2'b11

module id_fsm(
	input [7:0] char,
	input clk,
	output out
    );
	
	reg [1:0] status;
	reg isalphabet;
	reg isnumber;
	
	initial begin
		status = 2'b00;
	end
	
	always @(*) begin
		if ((char > 8'h40) && (char < 8'h5B))begin
			isalphabet = 1'b1;
		end
		else if ((char > 8'h60) && (char < 8'h7B)) begin
			isalphabet = 1'b1;
		end
		else begin
			isalphabet = 1'b0;//没有通过条件，一定要将信号复位
		end
	end

	always @(*) begin
		if ((char > 8'h2F) && (char < 8'h3A)) begin
			isnumber = 1'b1;
		end
		else begin
			isnumber = 1'b0;
		end
	end

	always @(posedge clk) begin
		case(status)
		`S0:begin
					if (isalphabet) begin
						status <= `S1;
					end
					else if (isnumber) begin
						status <= `S0;
					end
					else begin
						status <= `S0;
					end
				end
		`S1:begin
					if (isalphabet) begin
						status <= `S1;
					end
					else if (isnumber) begin
						status <= `S2;
					end
					else begin
						status <= `S0;
					end
				end
		`S2:begin
					if (isalphabet) begin
						status <= `S1;
					end
					else if (isnumber) begin
						status <= `S2;
					end
					else begin
						status <= `S0;
					end
				end
		default:begin
					status <= `S0;
				end
		endcase
	end

	assign out = (status == `S2) ? 1'b1 : 1'b0;

endmodule
