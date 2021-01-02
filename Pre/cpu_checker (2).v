`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:25:27 10/03/2020 
// Design Name: 
// Module Name:    cpu_checker 
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
`define S0 6'b000000
`define S1 6'b000001
`define S2 6'b000010
`define S3 6'b000011
`define S4 6'b000100
`define S5 6'b000101
`define S6 6'b000110
`define S7 6'b000111
`define S8 6'b001000
`define S9 6'b001001
`define S10 6'b001010
`define S11 6'b001011
`define S12 6'b001100
`define S13 6'b001101
`define S14 6'b001110
`define S15 6'b001111
`define S16 6'b010000
`define SR17 6'b010001
`define SR18 6'b010010
`define SR19 6'b010011
`define SR20 6'b010100
`define SR21 6'b010101
`define SR22 6'b010110
`define SR23 6'b010111
`define SR24 6'b011000
`define SR25 6'b011001
`define SR26 6'b011010
`define SR27 6'b011011
`define SR28 6'b011100
`define SR29 6'b011101
`define SR30 6'b011110
`define SR31 6'b011111
`define SR32 6'b100000
`define SR33 6'b100001
`define SR34 6'b100010
`define SS17 6'b100011
`define SS18 6'b100100
`define SS19 6'b100101
`define SS20 6'b100110
`define SS21 6'b100111
`define SS22 6'b101000
`define SS23 6'b101001
`define SS24 6'b101010
`define SS25 6'b101011
`define SS26 6'b101100
`define SS27 6'b101101
`define SS28 6'b101110
`define SS29 6'b101111
`define SS30 6'b110000
`define SS31 6'b110001
`define SS32 6'b110010
`define SS33 6'b110011
`define SS34 6'b110100
`define SS35 6'b110101
`define SS36 6'b110110
`define SS37 6'b110111
`define SS38 6'b111000

module cpu_checker(
	 input clk,
	 input reset,
	 input [7:0] char,
	 input [15:0] freq,
	 output [1:0] format_type,
	 output [3:0] error_code
    );
	reg [5:0] status;
	reg [15:0] timereg;
	reg [31:0] pcreg;
	reg [31:0] addrreg;
	reg [7:0] grfreg;
	
	wire [3:0] timewa;
	wire [3:0] pcwa;
	wire [3:0] addrwa;
	wire [3:0] grfwa;

	reg ishexalphabet; //判断是否为16进制字母的信号
	reg isnumber; //判断是否为数字的信号

	always @(char) begin				//判断是否为16进制字母
		if ((char > 8'h60) && (char < 8'h67)) begin
			ishexalphabet = 1'b1;
		end
		else begin
			ishexalphabet = 1'b0;
		end
	end

	always @(char) begin				//判断是否为数字
		if ((char > 8'h2F) && (char < 8'h3A)) begin
			isnumber = 1'b1;
		end
		else begin
			isnumber = 1'b0;
		end
	end

	always @(posedge clk) begin
		if (reset == 1'b1) begin
			status <= `S0;
			timereg <= 16'b0;
			pcreg <= 32'b0;
			addrreg <= 32'b0;
			grfreg <= 8'b0;
		end
		else begin
			case(status)
			`S0:begin
						if (char == "^") begin
							status <= `S1;
							timereg <= 16'b0;
							pcreg <= 32'b0;
							addrreg <= 32'b0;
							grfreg <= 8'b0;
						end
						else begin
							status <= `S0;
						end
					end
			`S1:begin
						if (isnumber) begin
							status <= `S2;
							timereg <= (timereg << 3) + (timereg << 1) + (char - 8'h30);
						end
						else begin
							status <= `S0;
						end
					end
			`S2:begin
						if (isnumber) begin
							status <= `S3;
							timereg <= (timereg << 3) + (timereg << 1) + (char - 8'h30);
						end
						else if (char == "@") begin
							status <= `S6;
						end
						else begin
							status <= `S0;
						end
					end
			`S3:begin
						if (isnumber) begin
							status <= `S4;
							timereg <= (timereg << 3) + (timereg << 1) + (char - 8'h30);
						end
						else if (char == "@") begin
							status <= `S6;
						end
						else begin
							status <= `S0;
						end
					end
			`S4:begin
						if (isnumber) begin
							status <= `S5;
							timereg <= (timereg << 3) + (timereg << 1) + (char - 8'h30);
						end
						else if (char == "@") begin
							status <= `S6;
						end
						else begin
							status <= `S0;
						end
					end
			`S5:begin
						if (char == "@") begin
							status <= `S6;
						end
						else begin
							status <= `S0;
						end
					end
			`S6:begin
						if (isnumber || ishexalphabet) begin
							status <= `S7;
							if (isnumber) begin
								pcreg <= (pcreg << 4) + (char - 8'h30);
							end
							else begin
								pcreg <= (pcreg << 4) + (char - 8'd87);
							end
						end
						else begin
							status <= `S0;
						end
					end
			`S7:begin
						if (isnumber || ishexalphabet) begin
							status <= `S8;
							if (isnumber) begin
								pcreg <= (pcreg << 4) + (char - 8'h30);
							end
							else begin
								pcreg <= (pcreg << 4) + (char - 8'd87);
							end
						end
						else begin
							status <= `S0;
						end
					end
			`S8:begin
						if (isnumber || ishexalphabet) begin
							status <= `S9;
							if (isnumber) begin
								pcreg <= (pcreg << 4) + (char - 8'h30);
							end
							else begin
								pcreg <= (pcreg << 4) + (char - 8'd87);
							end
						end
						else begin
							status <= `S0;
						end
					end
			`S9:begin
						if (isnumber || ishexalphabet) begin
							status <= `S10;
							if (isnumber) begin
								pcreg <= (pcreg << 4) + (char - 8'h30);
							end
							else begin
								pcreg <= (pcreg << 4) + (char - 8'd87);
							end
						end
						else begin
							status <= `S0;
						end
					end
			`S10:begin
						if (isnumber || ishexalphabet) begin
							status <= `S11;
							if (isnumber) begin
								pcreg <= (pcreg << 4) + (char - 8'h30);
							end
							else begin
								pcreg <= (pcreg << 4) + (char - 8'd87);
							end
						end
						else begin
							status <= `S0;
						end
					end
			`S11:begin
						if (isnumber || ishexalphabet) begin
							status <= `S12;
							if (isnumber) begin
								pcreg <= (pcreg << 4) + (char - 8'h30);
							end
							else begin
								pcreg <= (pcreg << 4) + (char - 8'd87);
							end
						end
						else begin
							status <= `S0;
						end
					end
			`S12:begin
						if (isnumber || ishexalphabet) begin
							status <= `S13;
							if (isnumber) begin
								pcreg <= (pcreg << 4) + (char - 8'h30);
							end
							else begin
								pcreg <= (pcreg << 4) + (char - 8'd87);
							end
						end
						else begin
							status <= `S0;
						end
					end
			`S13:begin
						if (isnumber || ishexalphabet) begin
							status <= `S14;
							if (isnumber) begin
								pcreg <= (pcreg << 4) + (char - 8'h30);
							end
							else begin
								pcreg <= (pcreg << 4) + (char - 8'd87);
							end
						end
						else begin
							status <= `S0;
						end
					end
			`S14:begin
						if (char == ":") begin
							status <= `S15;
						end
						else begin
							status <= `S0;
						end
					end
			`S15:begin
						if (char == " ") begin
							status <= `S16;
						end
						else if (char == "$") begin
							status <= `SR17;
						end
						else if (char == 8'd42) begin
							status <= `SS17;
						end
						else begin
							status <= `S0;
						end
					end
			`S16:begin
						if (char == " ") begin
							status <= `S16;
						end
						else if (char == "$") begin
							status <= `SR17;
						end
						else if (char == 8'd42) begin
							status <= `SS17;
						end
						else begin
							status <= `S0;
						end
					end
			`SR17:begin
						if (isnumber) begin
							status <= `SR18;
							grfreg <= (grfreg << 3) + (grfreg << 1) + (char - 8'h30);
						end
						else begin
							status <= `S0;
						end
					end
			`SR18:begin
						if (isnumber) begin
							status <= `SR19;
							grfreg <= (grfreg << 3) + (grfreg << 1) + (char - 8'h30);
						end
						else if (char == " ") begin
							status <= `SR22;
						end
						else if (char == "<") begin
							status <= `SR23;
						end
						else begin
							status <= `S0;
						end
					end
			`SR19:begin
						if (isnumber) begin
							status <= `SR20;
							grfreg <= (grfreg << 3) + (grfreg << 1) + (char - 8'h30);
						end
						else if (char == " ") begin
							status <= `SR22;
						end
						else if (char == "<") begin
							status <= `SR23;
						end
						else begin
							status <= `S0;
						end
					end
			`SR20:begin
						if (isnumber) begin
							status <= `SR21;
							grfreg <= (grfreg << 3) + (grfreg << 1) + (char - 8'h30);
						end
						else if (char == " ") begin
							status <= `SR22;
						end
						else if (char == "<") begin
							status <= `SR23;
						end
						else begin
							status <= `S0;
						end
					end
			`SR21:begin
						if (char == " ") begin
							status <= `SR22;
						end
						else if (char == "<") begin
							status <= `SR23;
						end
						else begin
							status <= `S0;
						end
					end
			`SR22:begin
						if (char == " ") begin
							status <= `SR22;
						end
						else if (char == "<") begin
							status <= `SR23;
						end
						else begin
							status <= `S0;
						end
					end
			`SR23:begin
						if (char == "=") begin
							status <= `SR24;
						end
						else begin
							status <= `S0;
						end
					end
			`SR24:begin
						if (char == " ") begin
							status <= `SR25;
						end
						else if (isnumber || ishexalphabet) begin
							status <= `SR26;
						end
						else begin
							status <= `S0;
						end
					end
			`SR25:begin
						if (char == " ") begin
							status <= `SR25;
						end
						else if (isnumber || ishexalphabet) begin
							status <= `SR26;
						end
						else begin
							status <= `S0;
						end
					end
			`SR26:begin
						if (isnumber || ishexalphabet) begin
							status <= `SR27;
						end
						else begin
							status <= `S0;
						end
					end
			`SR27:begin
						if (isnumber || ishexalphabet) begin
							status <= `SR28;
						end
						else begin
							status <= `S0;
						end
					end
			`SR28:begin
						if (isnumber || ishexalphabet) begin
							status <= `SR29;
						end
						else begin
							status <= `S0;
						end
					end
			`SR29:begin
						if (isnumber || ishexalphabet) begin
							status <= `SR30;
						end
						else begin
							status <= `S0;
						end
					end
			`SR30:begin
						if (isnumber || ishexalphabet) begin
							status <= `SR31;
						end
						else begin
							status <= `S0;
						end
					end
			`SR31:begin
						if (isnumber || ishexalphabet) begin
							status <= `SR32;
						end
						else begin
							status <= `S0;
						end
					end
			`SR32:begin
						if (isnumber || ishexalphabet) begin
							status <= `SR33;
						end
						else begin
							status <= `S0;
						end
					end
			`SR33:begin
						if (char == "#") begin
							status <= `SR34;
						end
						else begin
							status <= `S0;
						end
					end
			`SR34:begin
						if (char == "^") begin
							status <= `S1;
							timereg <= 16'b0;
							pcreg <= 32'b0;
							addrreg <= 32'b0;
							grfreg <= 8'b0;
						end
						else begin
							status <= `S0;
						end
					end
			`SS17:begin
						if (isnumber || ishexalphabet) begin
							status <= `SS18;
							if (isnumber) begin
								addrreg <= (addrreg << 4) + (char - 8'h30);
							end
							else begin
								addrreg <= (addrreg << 4) + (char - 8'd87);
							end
						end
						else begin
							status <= `S0;
						end
					end
			`SS18:begin
						if (isnumber || ishexalphabet) begin
							status <= `SS19;
							if (isnumber) begin
								addrreg <= (addrreg << 4) + (char - 8'h30);
							end
							else begin
								addrreg <= (addrreg << 4) + (char - 8'd87);
							end
						end
						else begin
							status <= `S0;
						end
					end
			`SS19:begin
						if (isnumber || ishexalphabet) begin
							status <= `SS20;
							if (isnumber) begin
								addrreg <= (addrreg << 4) + (char - 8'h30);
							end
							else begin
								addrreg <= (addrreg << 4) + (char - 8'd87);
							end
						end
						else begin
							status <= `S0;
						end
					end
			`SS20:begin
						if (isnumber || ishexalphabet) begin
							status <= `SS21;
							if (isnumber) begin
								addrreg <= (addrreg << 4) + (char - 8'h30);
							end
							else begin
								addrreg <= (addrreg << 4) + (char - 8'd87);
							end
						end
						else begin
							status <= `S0;
						end
					end
			`SS21:begin
						if (isnumber || ishexalphabet) begin
							status <= `SS22;
							if (isnumber) begin
								addrreg <= (addrreg << 4) + (char - 8'h30);
							end
							else begin
								addrreg <= (addrreg << 4) + (char - 8'd87);
							end
						end
						else begin
							status <= `S0;
						end
					end
			`SS22:begin
						if (isnumber || ishexalphabet) begin
							status <= `SS23;
							if (isnumber) begin
								addrreg <= (addrreg << 4) + (char - 8'h30);
							end
							else begin
								addrreg <= (addrreg << 4) + (char - 8'd87);
							end
						end
						else begin
							status <= `S0;
						end
					end
			`SS23:begin
						if (isnumber || ishexalphabet) begin
							status <= `SS24;
							if (isnumber) begin
								addrreg <= (addrreg << 4) + (char - 8'h30);
							end
							else begin
								addrreg <= (addrreg << 4) + (char - 8'd87);
							end
						end
						else begin
							status <= `S0;
						end
					end
			`SS24:begin
						if (isnumber || ishexalphabet) begin
							status <= `SS25;
							if (isnumber) begin
								addrreg <= (addrreg << 4) + (char - 8'h30);
							end
							else begin
								addrreg <= (addrreg << 4) + (char - 8'd87);
							end
						end
						else begin
							status <= `S0;
						end
					end
			`SS25:begin
						if (char == " ") begin
							status <= `SS26;
						end
						else if (char == "<") begin
							status <= `SS27;
						end
						else begin
							status <= `S0;
						end
					end
			`SS26:begin
						if (char == " ") begin
							status <= `SS26;
						end
						else if (char == "<") begin
							status <= `SS27;
						end
						else begin
							status <= `S0;
						end
					end
			`SS27:begin
						if (char == "=") begin
							status <= `SS28;
						end
						else begin
							status <= `S0;
						end
					end
			`SS28:begin
						if (char == " ") begin
							status <= `SS29;
						end
						else if (isnumber || ishexalphabet) begin
							status <= `SS30;
						end
						else begin
							status <= `S0;
						end
					end
			`SS29:begin
						if (char == " ") begin
							status <= `SS29;
						end
						else if (isnumber || ishexalphabet) begin
							status <= `SS30;
						end
						else begin
							status <= `S0;
						end
					end
			`SS30:begin
						if (isnumber || ishexalphabet) begin
							status <= `SS31;
						end
						else begin
							status <= `S0;
						end
					end
			`SS31:begin
						if (isnumber || ishexalphabet) begin
							status <= `SS32;
						end
						else begin
							status <= `S0;
						end
					end
			`SS32:begin
						if (isnumber || ishexalphabet) begin
							status <= `SS33;
						end
						else begin
							status <= `S0;
						end
					end
			`SS33:begin
						if (isnumber || ishexalphabet) begin
							status <= `SS34;
						end
						else begin
							status <= `S0;
						end
					end
			`SS34:begin
						if (isnumber || ishexalphabet) begin
							status <= `SS35;
						end
						else begin
							status <= `S0;
						end
					end
			`SS35:begin
						if (isnumber || ishexalphabet) begin
							status <= `SS36;
						end
						else begin
							status <= `S0;
						end
					end
			`SS36:begin
						if (isnumber || ishexalphabet) begin
							status <= `SS37;
						end
						else begin
							status <= `S0;
						end
					end
			`SS37:begin
						if (char == "#") begin
							status <= `SS38;
						end
						else begin
							status <= `S0;
						end
					end
			`SS38:begin
						if (char == "^") begin
							status <= `S1;
							timereg <= 16'b0;
							pcreg <= 32'b0;
							addrreg <= 32'b0;
							grfreg <= 8'b0;
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
	end
	
	assign format_type = (status == `SR34) ? 2'b01 :
								(status == `SS38) ? 2'b10 :
														  2'b00;
	
	assign timewa = (timereg & ((freq >> 1) - 16'b1)) ? 4'b0001 : 4'b0000;
	assign pcwa = (((pcreg >= 32'h00003000) && (pcreg <= 32'h00004fff)) && ((pcreg & 3) == 0))? 4'b0000 : 4'b0010;
	assign addrwa = (((addrreg >= 32'h00000000) && (addrreg <= 32'h00002fff)) && (addrreg[1:0] == 2'h0)) ? 4'b0000 : 4'b0100;
	assign grfwa = ((grfreg >= 8'd0) && (grfreg <= 8'd31)) ? 4'b0000 : 4'b1000;
	
	assign error_code = ((status == `SR34) || (status == `SS38)) ? (timewa | pcwa | addrwa | grfwa) : 4'b0000;
	
endmodule
