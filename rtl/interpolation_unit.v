`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/08/03 09:00:16
// Design Name: 
// Module Name: interpolation_unit
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


module interpolation_unit_1(
    input clk, rst_n,
    input [1:0] a0, a1,
    output reg [5:0] sample
    );
    localparam TAP0 = 3'd4;
    localparam TAP1 = 3'd0;
    
    reg [5:0] mem0 [0:3];
    reg [5:0] mem1 [0:3];
    
    initial begin
        mem0[0] = 6'd0;
        mem0[1] = 6'd17;
        mem0[2] = 6'd35;
        mem0[3] = 6'd52;
        mem1[0] = 6'd0;
        mem1[1] = 6'd0;
        mem1[2] = 6'd0;
        mem1[3] = 6'd0;
    end
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) sample <= 6'd0;
        else sample <= mem0[a0] + mem1[a1];
    end
    
endmodule

module interpolation_unit_2(
    input clk, rst_n,
    input [1:0] a0, a1,
    output reg [5:0] sample
    );
    localparam TAP0 = 3'd3;
    localparam TAP1 = 3'd1;
    
    reg [5:0] mem0 [0:3];
    reg [5:0] mem1 [0:3];
    
    initial begin
        mem0[0] = 6'd0;
        mem0[1] = 6'd15;
        mem0[2] = 6'd31;
        mem0[3] = 6'd46;
        mem1[0] = 6'd0;
        mem1[1] = 6'd5;
        mem1[2] = 6'd9;
        mem1[3] = 6'd14;
    end
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) sample <= 6'd0;
        else sample <= mem0[a0] + mem1[a1];
    end
    
endmodule

module interpolation_unit_3(
    input clk, rst_n,
    input [1:0] a0, a1,
    output reg [5:0] sample
    );
    localparam TAP0 = 3'd2;
    localparam TAP1 = 3'd2;
    
    reg [5:0] mem0 [0:3];
    reg [5:0] mem1 [0:3];
    
    initial begin
        mem0[0] = 6'd0;
        mem0[1] = 6'd10;
        mem0[2] = 6'd21;
        mem0[3] = 6'd31;
        mem1[0] = 6'd0;
        mem1[1] = 6'd10;
        mem1[2] = 6'd21;
        mem1[3] = 6'd31;
    end
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) sample <= 6'd0;
        else sample <= mem0[a0] + mem1[a1];
    end
    
endmodule

module interpolation_unit_4(
    input clk, rst_n,
    input [1:0] a0, a1,
    output reg [5:0] sample
    );
    localparam TAP0 = 3'd1;
    localparam TAP1 = 3'd3;
    
    reg [5:0] mem0 [0:3];
    reg [5:0] mem1 [0:3];
    
    initial begin
        mem0[0] = 6'd0;
        mem0[1] = 6'd5;
        mem0[2] = 6'd9;
        mem0[3] = 6'd14;
        mem1[0] = 6'd0;
        mem1[1] = 6'd15;
        mem1[2] = 6'd31;
        mem1[3] = 6'd46;
    end
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) sample <= 6'd0;
        else sample <= mem0[a0] + mem1[a1];
    end
    
endmodule