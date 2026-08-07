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
    input [255:0] equalizer_coe,
    input [47:0] pam_threshold,
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
        .equalizer_coe(equalizer_coe),
        .pam_threshold(pam_threshold),
        .signal(signal),
        .signal_valid(signal_valid),
        .error(error)
    );
endmodule
