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
    input [767:0] adc_data,
    output [15:0] error
    );
    
    // 信号粗检测
    localparam ADC_WIDTH = 3'd6;
    localparam TRAIN_SEQ_WINDOW_WIDTH = 5'd16;  //简单化训练序列起始判别，只用一部分点
    wire [TRAIN_SEQ_WINDOW_WIDTH-1:0] train_seq_flag;
    reg start_flag;
    genvar i;
    generate
        for (i = 0; i < TRAIN_SEQ_WINDOW_WIDTH; i = i + 1) begin
            assign train_seq_flag[i] = (adc_data[ADC_WIDTH*i+:ADC_WIDTH] < 6'd28 | adc_data[ADC_WIDTH*i+:ADC_WIDTH] > 6'd36)? 1'b1:1'b0;
        end
    endgenerate
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) start_flag <= 1'b0;
        else if(train_seq_flag) start_flag <= 1'b1;
    end

    // 寻找相关峰索引
    wire [6:0] max_addr;
    wire correlation_finish;
    cross_correlation u_cross_correlation(
        .clk(clk),
        .rst_n(rst_n),
        .start_flag(start_flag),
        .data_in(adc_data),
        .max_addr(max_addr),
        .data_out_valid(correlation_finish)
    );
    
    // 移位同步
    wire [767:0] aligned_data;
    wire aligned_valid;
    point_move_lock u_point_move_lock(
        .clk(clk),
        .adc_data_in(adc_data),
        .max_addr(max_addr),
        .cross_correlation_finish(correlation_finish),
        .addr_bias_flag(2'd0),
        .real_addr(),
        .adc_data_out_valid(aligned_valid),
        .adc_data_out(aligned_data),
        .addr_set_flag(1'b0),
        .addr_set_value(7'b0)
    );
    
    wire start_threshold = 6'd15;
    wire encrypted_data_valid;
    wire [767:0] encrypted_data_pre,encrypted_data,encrypted_data_after;
    // 训练序列-发射序列切换检测
    start_point_discrimination inst_start_point_discrimination(
        .clk(clk),
        .rst_n(rst_n),
        .threshold(start_threshold),
        .adc_data_align_valid(aligned_valid),
        .adc_data_align(aligned_data),
        .encrypted_data_valid(encrypted_data_valid),
        .encrypted_data_pre(encrypted_data_pre),
        .encrypted_data(encrypted_data),
        .encrypted_data_after(encrypted_data_after)
    );
    
    // 4倍抽取
    wire sample_valid;
    wire [191:0] sample;
    sampling u_sampling(
        .signal(encrypted_data),
        .signal_valid(encrypted_data_valid),
        .sample_valid(sample_valid),
        .sample_out(sample) 
    );
    
    // 信道均衡
    wire equalized_sample_valid;
    wire [511:0] equalized_sample;    //16位*32
    equalizer u_equalizer(
        .clk(clk),
        .rst_n(rst_n),
        .x(sample),
        .x_valid(sample_valid),
        .y(equalized_sample),
        .y_valid(equalized_sample_valid) 
    );
    
    // 判决
    wire bit_valid;
    wire [63:0] bit;
    wire [47:0] pam_threshold;
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
    tx_rom key_lib(
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