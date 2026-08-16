`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/08/03 08:57:44
// Design Name: 
// Module Name: rc_filter
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


module rc_filter(
    input clk, rst_n,
    input [63:0] bit,
    input bit_valid,
    output reg sample_valid,
    output [767:0] sample
    );
    
    // 默认发送训练序列
    reg [1:0] train_seq [0:31];
    // 初始化
    initial begin
        $readmemb("train_sequence_32x2.mem", train_seq);
    end
    
    //符号寄存
    integer i;
    reg [1:0] symbol [0:32];
    always @(posedge clk or negedge rst_n)begin
        for (i=0;i<=32;i=i+1)begin
            if(!rst_n) symbol[i] <= 2'b0;
            else if(!bit_valid) begin 
                if(i==0) symbol[0] <= symbol[32];
                else symbol[i] <= train_seq[i-1];
            end
            else begin
                if(i==0) symbol[0] <= symbol[32];
                else symbol[i] <= bit[2*i-2+:2];
            end
        end
    end
    
    //成形滤波
    genvar j;
    generate 
        for (j=0;j<32;j=j+1)begin:u_interpolation
            interpolation u_interpolation(
                .clk(clk),
                .rst_n(rst_n),
                .a0(symbol[j]),
                .a1(symbol[j+1]),
                .sample(sample[24*j+:24])
            );
        end
    endgenerate
    
    // 输出有效位
    reg bit_valid_d;
    always @(posedge clk or negedge rst_n)begin
        if(!rst_n){sample_valid, bit_valid_d} <= 0;
        else {sample_valid, bit_valid_d} <= {bit_valid_d, bit_valid};
    end
endmodule
