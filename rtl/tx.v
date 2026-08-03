`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/08/01 15:43:20
// Design Name: 
// Module Name: tx
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


module tx(
    input clk, rst_n, en,
    output sample_valid,
    output [767:0] sample
    );
    
    // 64*64原始比特库
    wire [63:0] raw_bit;
    wire raw_bit_valid;
    rom bit_lib(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .rdata(raw_bit),
        .rdata_valid(raw_bit_valid)
        
    );
    
    // 64*64密钥库
    wire [63:0] key;
    wire key_valid;
    rom key_lib(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .rdata(key),
        .rdata_valid(key_valid)
    );
    
    // des加密模块
    wire [63:0] encrypt_bit;
    wire encrypt_valid;
    des encrypt(
        .clk(clk),
        .rst(rst_n),
        .text(raw_bit),        
        .key(key),         
        .key_valid(key_valid),   
        .text_valid(raw_bit_valid),  
        .decrypt(0),     
        .result(encrypt_bit),      
        .result_valid(encrypt_valid)
    );
    
    // 升余弦成形滤波
    wire tx_rc_ready;
    wire bit_valid;
    wire [63:0] bit;
    rc_filter pulse_shaping(
        .clk(clk),
        .rst_n(rst_n),
        .bit(encrypt_bit),
        .bit_valid(encrypt_valid),
        .sample(sample),
        .sample_valid(sample_valid) 
    );
endmodule
