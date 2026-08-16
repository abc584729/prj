`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/18 11:06:16
// Design Name: 
// Module Name: unsigned_error_cal
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


module unsigned_error_cal(
    clk,data_a,data_b,data_valid,
    result,result_valid
    );
localparam DATA_WIDTH = 3'd6;
input clk;
input [DATA_WIDTH-1:0] data_a,data_b;
input data_valid;
output reg [DATA_WIDTH-1:0] result;
output reg result_valid;

always @(posedge clk) begin
    if(data_valid) begin
        if(data_a < data_b) result <= data_b - data_a;
        else if(data_a > data_b) result <= data_a - data_b;
        else result <= 6'd0;
        result_valid <= 6'd1;
    end
    else result_valid <= 1'b0;
end
endmodule
