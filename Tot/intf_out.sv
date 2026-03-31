`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2026 08:57:02 AM
// Design Name: 
// Module Name: intf_out
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


interface intf_out(input logic clk_i, rst_ni);

logic [7:0] count_o;
logic       ovf_o;

clocking monitor_cb @(posedge clk_i);
    default input #1 output #1;
    input count_o;
    input ovf_o;
endclocking

modport MONITOR(clocking monitor_cb, input clk_i, rst_ni);

endinterface
