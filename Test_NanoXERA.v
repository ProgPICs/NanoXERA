`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:51:24 11/24/2019 
// Design Name: 
// Module Name:    Test_NanoXERA 
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
module Test_NanoXERA(
	input clk,
	output [7:0]indata
    );


reg [7:0] outdata;
wire [7:0] address;
reg [7:0] RAM [0:255];

initial begin
 $readmemh("Test_NanoXERA.txt", RAM, 0);
end

always @(posedge clk) begin
	if (we) RAM[address]<=indata;
	else outdata<=RAM[address];
end

NanoXERA CPU(
	.clk(clk),
	.indata(outdata),
	.A(indata),
	.address(address),
	.we(we)
    );

endmodule
