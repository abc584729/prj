`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/08/03 08:58:24
// Design Name: 
// Module Name: interpolation
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module interpolation(
    input clk, rst_n,
    input [1:0] a0, a1,
    output [23:0] sample
    );
    
    interpolation_unit_1 sample1(
        .clk(clk),
        .rst_n(rst_n),
        .a0(a0),
        .a1(a1),
        .sample(sample[5:0])
    );
    
        interpolation_unit_2 sample2(
        .clk(clk),
        .rst_n(rst_n),
        .a0(a0),
        .a1(a1),
        .sample(sample[11:6])
    );
    
        interpolation_unit_3 sample3(
        .clk(clk),
        .rst_n(rst_n),
        .a0(a0),
        .a1(a1),
        .sample(sample[17:12])
    );
    
        interpolation_unit_4 sample4(
        .clk(clk),
        .rst_n(rst_n),
        .a0(a0),
        .a1(a1),
        .sample(sample[23:18])
    );
endmodule
