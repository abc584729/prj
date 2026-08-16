`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/15 15:01:43
// Design Name: 
// Module Name: start_point_discrimination
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


module start_point_discrimination(
    input clk,
    input rst_n,
    input [5:0] threshold,
    input adc_data_align_valid,
    input [767:0] adc_data_align,
    output reg encrypted_data_valid,
    output reg [767:0] encrypted_data_pre,
    output reg [767:0] encrypted_data,
    output reg [767:0] encrypted_data_after
    );
localparam ADC_WIDTH = 3'd6;
localparam WINDOW_WIDTH = 8'd128;

wire [ADC_WIDTH-1:0] adc_data_align_slice[0:WINDOW_WIDTH-1];
reg [767:0] adc_data_align_b1,adc_data_align_b2,adc_data_align_b3;
wire [ADC_WIDTH-1:0] adc_data_align_b1_slice[0:WINDOW_WIDTH-1];
//inst_unsigned_error_cal
wire [ADC_WIDTH-1:0] error_result[0:WINDOW_WIDTH-1];
wire [WINDOW_WIDTH-1:0] error_result_valid;
wire [WINDOW_WIDTH-1:0] error_threshold_flag;
wire [767:0] error_result_group;

reg encrypted_data_start;

always @(posedge clk) begin
    adc_data_align_b1 <= adc_data_align;
    adc_data_align_b2 <= adc_data_align_b1;
end
genvar i;
generate
    for (i = 0; i < WINDOW_WIDTH; i = i + 1) begin
        assign adc_data_align_slice[i] = adc_data_align[ADC_WIDTH*i+:ADC_WIDTH];
        assign adc_data_align_b1_slice[i] = adc_data_align_b1[ADC_WIDTH*i+:ADC_WIDTH];
        unsigned_error_cal inst_unsigned_error_cal(
            clk,adc_data_align_slice[i],adc_data_align_b1_slice[i],adc_data_align_valid,
            error_result[i],error_result_valid[i]
        );
        assign error_threshold_flag[i] = (error_result[i] > threshold)? 1'b1:1'b0;
        assign error_result_group[ADC_WIDTH*i+:ADC_WIDTH] = error_result[i];
    end
endgenerate
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) encrypted_data_start <= 1'b0;
    else if(error_result_valid[0] && error_threshold_flag) encrypted_data_start <= 1'b1;
end
always @(posedge clk) begin
    if(encrypted_data_start) begin
        encrypted_data_pre <= {adc_data_align_b1[5:0],adc_data_align_b2[767:6]};
        encrypted_data <= adc_data_align_b2;
        encrypted_data_after <= {adc_data_align_b2[761:0],adc_data_align_b3[767:762]};
        encrypted_data_valid <= 1'b1;
    end
    else encrypted_data_valid <= 1'b0;
end
endmodule
