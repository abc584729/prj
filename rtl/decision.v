`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/08/03 10:54:19
// Design Name: 
// Module Name: decision
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


module decision(
    input clk, rst_n,
    input signal_valid,
    input [511:0] signal,
    input [47:0] threshold,
    output reg bit_valid,
    output [63:0] bit_out
    );
    
    wire [15:0] threshold_1;
    wire [15:0] threshold_2;
    wire [15:0] threshold_3;

    assign threshold_1 = threshold[15:0];
    assign threshold_2 = threshold[31:16];
    assign threshold_3 = threshold[47:32];

    reg [63:0] bit;
    // 抽样判决        
    integer i;
    always @(posedge clk or negedge rst_n)begin
        for (i=0;i<32;i=i+1)begin
            if(!rst_n) bit[2*i+:2] <= 0;
            else begin
                if (signal[16*i+:16]< threshold_1) bit[2*i+:2] <= 2'b00;
                else if (signal[16*i+:16]< threshold_2) bit[2*i+:2] <= 2'b01;
                else if (signal[16*i+:16]< threshold_3) bit[2*i+:2] <= 2'b10;
                else bit[2*i+:2] <= 2'b11;
            end
        end
    end
    
    // 保存上一组判决比特
    reg [63:0] bit_d;
    always @(posedge clk or negedge rst_n)begin
        if(!rst_n) bit_d <= 0;
        else bit_d <= bit;
    end
    
    // 输出比特为上一组后63个判决比特和当前组第一个判决比特
    assign bit_out = {bit[1:0],bit_d[63:2]};
    
    // 有效位输出
    // 多打一拍补偿滤波器延时
    reg signal_valid_d;
    always @(posedge clk or negedge rst_n)begin
        if(!rst_n){bit_valid, signal_valid_d} <= 0;
        else {bit_valid, signal_valid_d} <= {signal_valid_d, signal_valid};
    end
endmodule
