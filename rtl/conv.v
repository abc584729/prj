`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/08/07 16:00:29
// Design Name: 
// Module Name: conv
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


module conv(
    input clk, rst_n,
    input [95:0] x_in,
    output [15:0] y
    );
    
    // 输入拆分
    genvar j;
    wire [5:0] x[0:15];
    generate 
        for (j=0;j<16;j=j+1)begin
            assign x[j] = x_in[6*j+:6];
        end
    endgenerate 
    
    // 系数拆分
    reg [15:0] tap[0:15];
    initial begin 
        $readmemb("equalizer.mem", tap);
    end
    
    reg signed [22:0] mult [0:15];
    reg signed [23:0] add0 [0:7];
    reg signed [24:0] add1 [0:3];
    reg signed [25:0] add2 [0:1];
    reg signed [26:0] add3;

    // 逐元素相乘
    integer i;
    always @(posedge clk or negedge rst_n )begin
        for(i=0;i<16;i=i+1)begin 
            if(!rst_n) mult[i] <= 0;
            else mult[i] <= $signed({1'b0,x[i]})* $signed(tap[i]);
        end
    end
    
    // 4级加法器树
    always @(posedge clk or negedge rst_n )begin
        for(i=0;i<8;i=i+1)begin 
            if(!rst_n) add0[i] <= 0;
            else add0[i] <= mult[2*i] + mult[2*i+1];
        end
    end
    
    always @(posedge clk or negedge rst_n )begin
        for(i=0;i<4;i=i+1)begin 
            if(!rst_n) add1[i] <= 0;
            else add1[i] <= add0[2*i] + add0[2*i+1];
        end
    end
    
    always @(posedge clk or negedge rst_n )begin
        for(i=0;i<2;i=i+1)begin 
            if(!rst_n) add2[i] <= 0;
            else add2[i] <= add1[2*i] + add1[2*i+1];
        end
    end
    
    always @(posedge clk or negedge rst_n )begin 
        if(!rst_n) add3 <= 0;
        else add3 <= add2[0] + add2[1];
    end
    
    // 5个时钟周期后输出有效
    assign y = add3[26:11];    
    
endmodule
