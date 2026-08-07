`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/08/07 18:02:43
// Design Name: 
// Module Name: sampling
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


module sampling(
    input signal_valid,
    input [767:0] signal,
    output sample_valid,
    output reg [191:0] sample_out
    );
    
    // 4倍抽取
    integer i;
    always @* for (i=0;i<32;i=i+1) sample_out[6*i+:6] = signal[24*i+:6];
    
    //有效位
    assign sample_valid = signal_valid;
endmodule
