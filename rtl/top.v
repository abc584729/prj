`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/08/01 19:39:10
// Design Name: 
// Module Name: top
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


module top(
    input clk, rst_n, tx_en,
    output [15:0] error
    );
    
    wire [767:0] signal;
    wire signal_valid;
   
    tx u_tx(
        .clk(clk),
        .rst_n(rst_n),
        .en(tx_en),
        .sample(signal),
        .sample_valid(signal_valid)
    );
    
    rx u_rx(
        .clk(clk),
        .rst_n(rst_n),
        .signal(signal),
        .signal_valid(signal_valid),
        .error(error)
    );
endmodule
