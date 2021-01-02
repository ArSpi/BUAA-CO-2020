`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:33:59 11/29/2020 
// Design Name: 
// Module Name:    DM 
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
module DM(
	input wire clk,
	input wire reset,
	input wire [31:0] Instr_M,
	input wire [31:0] Addr,
	input wire [31:0] WD,
	input wire [31:0] PC,
	output wire [31:0] DMRD,
	//P7 other devices
	input wire [31:0] DevRD,
	input wire IntReq,
	input wire ExcReq
    );
	reg [31:0] DM [4095:0];
	integer i;
	
	initial begin
		for (i = 0; i < 4096; i = i + 1)
			DM[i] = 32'b0;
	end
	
	reg [31:0] RD;
	wire WE;
	wire lb, lbu, lh, lhu, lw, sb, sh, sw;
	Decoder code_DM(.Instr(Instr_M), .DMWE(WE), .lb(lb), .lbu(lbu), .lh(lh), .lhu(lhu), .lw(lw), .sb(sb), .sh(sh), .sw(sw));
	
	wire hitDM;
	assign hitDM = (32'h0000 <= Addr) && (Addr <= 32'h2fff);
	assign DMRD = (hitDM) ? RD : DevRD;
	
	//load
	wire [31:0] word;
	assign word = DM[Addr[13:2]];
	always @(*) begin
		if (lb) begin
			case(Addr[1:0])
				2'b00:RD = {{24{word[7]}}, word[7:0]};
				2'b01:RD = {{24{word[15]}}, word[15:8]};
				2'b10:RD = {{24{word[23]}}, word[23:16]};
				2'b11:RD = {{24{word[31]}}, word[31:24]};
			endcase
		end
		else if (lbu) begin
			case(Addr[1:0])
				2'b00:RD = {24'b0, word[7:0]};
				2'b01:RD = {24'b0, word[15:8]};
				2'b10:RD = {24'b0, word[23:16]};
				2'b11:RD = {24'b0, word[31:24]};
			endcase
		end
		else if (lh) begin
			case(Addr[1])
				1'b0:RD = {{16{word[15]}}, word[15:0]};
				1'b1:RD = {{16{word[31]}}, word[31:16]};
			endcase
		end
		else if (lhu) begin
			case(Addr[1])
				1'b0:RD = {16'b0, word[15:0]};
				1'b1:RD = {16'b0, word[31:16]};
			endcase
		end
		else if (lw) begin
			RD = word;
		end
		else begin
			RD = 32'b0;
		end
	end
	
	//store
	always @(posedge clk) begin
		if (reset == 1'b1) begin
			for (i = 0; i < 4096; i = i + 1)
				DM[i] <= 32'b0;
		end
		else if ((WE & hitDM) && (!IntReq && !ExcReq)) begin
			if (sb) begin
				case(Addr[1:0])
					2'b00:begin
								DM[Addr[13:2]][7:0] <= WD[7:0];
								$display("%d@%h: *%h <= %h", $time, PC, {Addr[31:2], 2'b00}, {DM[Addr[13:2]][31:8], WD[7:0]});
								//$display("@%h: *%h <= %h", PC, {Addr[31:2], 2'b00}, {DM[Addr[13:2]][31:8], WD[7:0]});
							end
					2'b01:begin
								DM[Addr[13:2]][15:8] <= WD[7:0];
								$display("%d@%h: *%h <= %h", $time, PC, {Addr[31:2], 2'b00}, {DM[Addr[13:2]][31:16], WD[7:0], DM[Addr[13:2]][7:0]});
								//$display("@%h: *%h <= %h", PC, {Addr[31:2], 2'b00}, {DM[Addr[13:2]][31:16], WD[7:0], DM[Addr[13:2]][7:0]});
							end
					2'b10:begin
								DM[Addr[13:2]][23:16] <= WD[7:0];
								$display("%d@%h: *%h <= %h", $time, PC, {Addr[31:2], 2'b00}, {DM[Addr[13:2]][31:24], WD[7:0], DM[Addr[13:2]][15:0]});
								//$display("@%h: *%h <= %h", PC, {Addr[31:2], 2'b00}, {DM[Addr[13:2]][31:24], WD[7:0], DM[Addr[13:2]][15:0]});
							end
					2'b11:begin
								DM[Addr[13:2]][31:24] <= WD[7:0];
								$display("%d@%h: *%h <= %h", $time, PC, {Addr[31:2], 2'b00}, {WD[7:0], DM[Addr[13:2]][23:0]});
								//$display("@%h: *%h <= %h", PC, {Addr[31:2], 2'b00}, {WD[7:0], DM[Addr[13:2]][23:0]});
							end
				endcase
			end
			else if (sh) begin
				case(Addr[1])
					1'b0: begin
								DM[Addr[13:2]][15:0] <= WD[15:0];
								$display("%d@%h: *%h <= %h", $time, PC, {Addr[31:2], 2'b00}, {DM[Addr[13:2]][31:16], WD[15:0]});
								//$display("@%h: *%h <= %h", PC, {Addr[31:2], 2'b00}, {DM[Addr[13:2]][31:16], WD[15:0]});
							end
					1'b1: begin
								DM[Addr[13:2]][31:16] <= WD[15:0];
								$display("%d@%h: *%h <= %h", $time, PC, {Addr[31:2], 2'b00}, {WD[15:0], DM[Addr[13:2]][15:0]});
								//$display("@%h: *%h <= %h", PC, {Addr[31:2], 2'b00}, {WD[15:0], DM[Addr[13:2]][15:0]});
							end
				endcase
			end
			else if (sw) begin
				DM[Addr[13:2]] <= WD;
				$display("%d@%h: *%h <= %h", $time, PC, {Addr[31:2], 2'b00}, WD);
				//$display("@%h: *%h <= %h", PC, {Addr[31:2], 2'b00}, WD);
			end
		end
	end

endmodule
