`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:21:16 11/15/2020 
// Design Name: 
// Module Name:    MUX 
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
module MUX1(
	input [31:0] IFU_Instr,
	input [1:0] MUX1,
	output reg [4:0] GRF_WA
    );
	always @(*) begin
		case(MUX1)
		2'b00:begin
				GRF_WA = IFU_Instr[20:16];
			end
		2'b01:begin
				GRF_WA = IFU_Instr[15:11];
			end
		2'b10:begin
				GRF_WA = 5'd31;
			end
		default:begin
				GRF_WA = 5'd30;
			end
		endcase
	end

endmodule

module MUX2(
	input [31:0] GRF_RD2,
	input [31:0] EXT_EXTimm,
	input MUX2,
	output reg [31:0] ALU_num2
    );
	always @(*) begin
		case(MUX2)
		1'b0:begin
				ALU_num2 = GRF_RD2;
			end
		1'b1:begin
				ALU_num2 = EXT_EXTimm;
			end
		default:begin
				ALU_num2 = 32'h12345678;
			end
		endcase
	end

endmodule

module MUX3(
	input [31:0] ALU_result,
	input [31:0] DM_RD,
	input [1:0] MUX3,
	input [31:0] PC4,
	output reg [31:0] GRF_WD
    );
	always @(*) begin
		case(MUX3)
			2'b00:begin
					GRF_WD = ALU_result;
				end
			2'b01:begin
					GRF_WD = DM_RD;
				end
			2'b10:begin
					GRF_WD = PC4;
				end
			default:begin
					GRF_WD = 32'h12345678;
				end
		endcase
	end

endmodule
