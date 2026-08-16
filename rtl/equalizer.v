`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/08/07 16:27:29
// Design Name: 
// Module Name: equalizer
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


module equalizer(
    input clk, rst_n,
    input [191:0] x,
    input x_valid,
    output [511:0] y,
    output y_valid

    );
    
    // 保存本时钟到来的32个序列
    reg [5:0] x_d[0:31];
    integer i;
    always @(posedge clk or negedge rst_n )begin
        for(i=0;i<32;i=i+1)begin 
            if(!rst_n) x_d[i] <= 0;
            else if(x_valid) x_d[i] <= x[6*i+:6];
            else x_d[i] <= 0;
        end
    end
    
    // 保存上一个时钟到来的后15个序列
    reg [5:0] x_prev[0:14];
    always @(posedge clk or negedge rst_n )begin
        for(i=0;i<15;i=i+1)begin 
            if(!rst_n) x_prev[i] <= 0;
            else if(x_valid) x_prev[i] <= x_d[17+i];
            else x_prev[i] <= 0;
        end
    end
    
    // 卷积
    wire [5:0] x_ext [0:46];
    wire [95:0] x_in[0:31];
    genvar row, col;
    generate 
        for(col=0;col<15;col=col+1)begin 
            assign x_ext[col] = x_prev[col];
        end
        for(col=0;col<32;col=col+1)begin 
            assign x_ext[15+col] = x_d[col];
        end
        for (row=0; row<32; row=row+1) begin : gen_conv
            for (col=0; col<16; col=col+1) begin : gen_window
                assign x_in[row][6*col+:6] = x_ext[row+col];
            end
            //卷积模块
            conv u_conv (
                .clk(clk),
                .rst_n(rst_n),
                .x_in(x_in[row]),
                .y(y[16*row +: 16])
            );
        end
    endgenerate 
    
    // 有效位输出
    reg [5:0] valid_pipe;
    always @(posedge clk or negedge rst_n )begin
        if(!rst_n) valid_pipe <= 6'b0;
        else valid_pipe <= {valid_pipe[4:0], x_valid};
    end

    assign y_valid = valid_pipe[5];
endmodule