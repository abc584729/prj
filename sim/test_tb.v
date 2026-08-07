`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/08/01 22:02:14
// Design Name: 
// Module Name: test_tb
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


module test_tb;

    reg clk,rst_n,tx_en;
    wire [15:0] error;
    reg [255:0] equalizer_coe = 0;
    reg [47:0] pam_threshold = 0;
        
    top dut(
        .clk(clk),
        .rst_n(rst_n),
        .tx_en(tx_en),
        .equalizer_coe(equalizer_coe),
        .pam_threshold(pam_threshold),
        .error(error)
    ); 
    
    always #5 clk = ~clk;
   
    initial begin
        clk = 0;
        rst_n = 0;
        tx_en = 0;
        #20 rst_n = 1;
        #20 tx_en = 1;
        #2000 tx_en = 0;
        #2000 tx_en = 1;
    end
    
endmodule
