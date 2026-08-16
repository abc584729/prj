`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/08/01 21:10:53
// Design Name: 
// Module Name: ber
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


module ber(
    input clk, rst_n,
    input [63:0] bit,
    input bit_valid,
    output reg [15:0] error
    );
    
    //例化与发射rom相同的mem
    parameter ASIZE = 5;
    parameter MEMDEPTH = 1<<ASIZE;
    reg [63:0] mem [0:MEMDEPTH-1];
    
    // 初始化
    initial begin
        mem[0]  = 64'hDF985DC72CEC2AE3;
        mem[1]  = 64'hD5F62392FA862F1B;
        mem[2]  = 64'h0DAAFB636FD1DA6D;
        mem[3]  = 64'h6D84247DAD484C95;
        mem[4]  = 64'hA081F8F6733329AD;
        mem[5]  = 64'h5D1AC20CB900606B;
        mem[6]  = 64'h25B2BD0406CE3028;
        mem[7]  = 64'h65831554367FC491;
        mem[8]  = 64'h6C275925562DB90E;
        mem[9]  = 64'h49E0D6F07F302EF6;
        mem[10] = 64'h92B96F09B991A321;
        mem[11] = 64'hAE51F63A1E4474EC;
        mem[12] = 64'h0AA486FCD2B3962F;
        mem[13] = 64'h952FABD070641506;
        mem[14] = 64'hB14D4E09B336E077;
        mem[15] = 64'h25D9613A173E6CEB;
        mem[16] = 64'h4CCC3A1F7E8B5D92;
        mem[17] = 64'h19F2A0C36D4E871B;
        mem[18] = 64'h55AA33BB11CC77EE;
        mem[19] = 64'h0F1E2D3C4B5A6978;
        mem[20] = 64'hA5B4C3D2E1F00123;
        mem[21] = 64'h6789ABCDEF012345;
        mem[22] = 64'h1122334455667788;
        mem[23] = 64'h99AABBCCDDEEFF00;
        mem[24] = 64'h1A2B3C4D5E6F7081;
        mem[25] = 64'h9A8B7C6D5E4F3021;
        mem[26] = 64'h1234567890ABCDEF;
        mem[27] = 64'hFEDCBA0987654321;
        mem[28] = 64'hC1D2E3F4A5B60718;
        mem[29] = 64'h8C7A6B5A49382716;
        mem[30] = 64'hDEADBEEFCAFEBABE;
        mem[31] = 64'h0123456789ABCDEF;
    end
    
    // 指针
    reg [ASIZE-1:0] ptr;
    
    // 输入比特有效后指针循环自增
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) ptr <= 0;
        else if(bit_valid) begin
            if(ptr == MEMDEPTH-1) ptr <= 0;
            else ptr <= ptr+1;
        end
        else ptr <= 0;
    end
    
    // 错误判断
    reg error_flag;
    always @(*) begin
        if(!rst_n) error_flag = 0;
        else if(bit_valid && bit != mem[ptr]) error_flag = 1;
        else error_flag = 0;
    end
    
    // 错误计数
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) error <= 0;
        else if(error_flag) error <= error + 1;
    end
    
 endmodule
