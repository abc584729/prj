`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/08/01 19:19:10
// Design Name: 
// Module Name: rx
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


module rx(
    input clk, rst_n,
    input signal_valid,
    input [767:0] signal,
    input [255:0] equalizer_coe,
    input [47:0] pam_threshold,
    output [15:0] error
    );
    
    // 4倍抽取
    wire sample_valid;
    wire [191:0] sample;
    sampling u_sampling(
        .signal(signal),
        .signal_valid(signal_valid),
        .sample_valid(sample_valid),
        .sample_out(sample) 
    );
    
    // 信道均衡
    wire equalized_sample_valid;
    wire [511:0] equalized_sample;    //16位*32
    equalizer u_equalizer(
        .clk(clk),
        .rst_n(rst_n),
        .coe(equalizer_coe),
        .x(sample),
        .x_valid(sample_valid),
        .y(equalized_sample),
        .y_valid(equalized_sample_valid) 
    );
    
    // 判决
    wire bit_valid;
    wire [63:0] bit;
    decision u_decision(
        .clk(clk),
        .rst_n(rst_n),
        .threshold(pam_threshold),
        .signal(equalized_sample),
        .signal_valid(equalized_sample_valid),
        .bit_valid(bit_valid),
        .bit_out(bit) 
    );

    // 32*64密钥库
    wire [63:0] key;
    wire key_valid;
    rom key_lib(
        .clk(clk),
        .rst_n(rst_n),
        .en(bit_valid),   
        .rdata(key),
        .rdata_valid(key_valid)
    );
    
    // des解密模块
    wire [63:0] decrypt_bit;
    wire decrypt_bit_valid;
    des decrypt(
        .clk(clk),
        .rst(rst_n),
        .text(bit),        
        .key(key),         
        .key_valid(key_valid),   
        .text_valid(bit_valid),  
        .decrypt(1),     
        .result(decrypt_bit),      
        .result_valid(decrypt_bit_valid)
    );
    
    // 误比特统计模块
    ber cal_error(
        .clk(clk),
        .rst_n(rst_n),
        .bit(decrypt_bit),
        .bit_valid(decrypt_bit_valid),
        .error(error)
    ); 
endmodule