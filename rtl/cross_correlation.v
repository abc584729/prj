`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/26 18:54:30
// Design Name: 
// Module Name: cross_correlation
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


module cross_correlation(
    clk,rst_n,start_flag,data_in,
    max_addr,data_out_valid
    );
localparam ADC_WIDTH = 3'd6;
localparam WINDOW_LENGTH = 8'd128;
parameter IDEL = 2'd0;
parameter CAL = 2'd1;
parameter PRECISE_DISC = 2'd2;//о╦еп╬Ж
parameter STOP = 2'd3;

input clk,rst_n,start_flag;
input [767:0] data_in;
output reg [6:0] max_addr;
output reg data_out_valid;

reg [1:0] curr_state,next_state;
reg [767:0] data;
wire [ADC_WIDTH-1:0] data_slice[0:127];
reg [ADC_WIDTH-1:0] data_slice_b1;
reg [11:0] mult_result;
reg accum_data_valid,accum_data_valid_b1;
reg [17:0] accum_result,old_accum_result;
reg [7:0] count;
reg cal_finish_flag;
reg precise_disc_finish_flag;
reg finish_flag;
//inst_dram_correlation_coefficient
reg [6:0] rom_addr;
wire [ADC_WIDTH-1:0] rom_data;

genvar i;
generate
    for (i = 0; i < 128; i = i + 1) begin
        assign data_slice[i] = data[ADC_WIDTH*i+:ADC_WIDTH];
    end
endgenerate
always @(posedge clk) begin
    accum_data_valid_b1 <= accum_data_valid;
    data_out_valid <= finish_flag;
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) curr_state <= IDEL;            
    else curr_state <= next_state;
end
always @(*) begin
    case(curr_state)
        IDEL: begin
            if(start_flag) next_state = CAL;
            else next_state = IDEL;
        end
        CAL: begin
            if(cal_finish_flag) next_state = PRECISE_DISC;                                    
            else next_state = CAL;
        end
        PRECISE_DISC: begin
            if(precise_disc_finish_flag) next_state = STOP;
            else next_state = CAL;
        end
        STOP: next_state = STOP;
        default: next_state = IDEL;
    endcase
end
always @(posedge clk) begin
    case(curr_state)
    IDEL:begin
        data <= data_in;
        accum_data_valid <= 1'b0;
        count <= 8'd0;
        cal_finish_flag <= 1'b0;
        precise_disc_finish_flag <= 1'b0;
        rom_addr <= 7'd0;
        finish_flag <= 1'b0;
    end
    CAL:begin
        if(rom_addr == 7'd127) cal_finish_flag <= 1'b1;
        else rom_addr <= rom_addr + 1'b1;
        if(rom_addr != 7'd0) accum_data_valid <= 1'b1;
        if(count == 8'd127) precise_disc_finish_flag <= 1'b1;
    end
    PRECISE_DISC:begin
        accum_data_valid <= 1'b0;
        data <= {data[5:0],data[6*128-1:6]};
        count <= count + 1'b1;
        cal_finish_flag <= 1'b0;
        rom_addr <= 7'd0;
    end
    STOP:finish_flag <= 1'b1;
    endcase
end
//mult
always @(posedge clk) begin
    data_slice_b1 <= data_slice[rom_addr];
    mult_result <= rom_data * data_slice_b1;
end
//accum
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) accum_result <= 18'd0;
    else if(accum_data_valid) accum_result <= accum_result + mult_result;
    else accum_result <= 18'd0;
end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin 
        old_accum_result <= 18'd0;
        max_addr <= 7'd0;
    end
    else if(!accum_data_valid && accum_data_valid_b1) begin
        if(accum_result > old_accum_result) begin
            max_addr <= count - 1'b1;
            old_accum_result <= accum_result;
        end
    end
//    else if(count == 8'd0) old_accum_result <= 18'd0;
end

reg [6:0] rom_addr_d;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) rom_addr_d <= 0;
    else rom_addr_d <= rom_addr;
end
reg [ADC_WIDTH-1:0] correlation_rom [0:127];
initial begin $readmemb("corr_template_128x6.mem", correlation_rom);end
assign rom_data = correlation_rom[rom_addr_d];
endmodule
