`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2026 08:46:47 AM
// Design Name: 
// Module Name: intf_in
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

interface intf_in(input logic clk, rst_ni);

logic valid_i;
logic rd_wr_i;
logic [1:0] addr_i;
logic [7:0] d_in;
logic [7:0] d_out;

clocking driver_cb @(posedge clk);
    default input #1 output #1;
    output valid_i;
    output rd_wr_i;
    output addr_i;
    output d_in;
    input  d_out;
endclocking

clocking monitor_cb @(posedge clk);
    default input #1 output #1;
    input valid_i;
    input rd_wr_i;
    input addr_i;
    input d_in;
    input d_out;
endclocking

modport DRIVER (clocking driver_cb, input clk, rst_ni);
modport MONITOR(clocking monitor_cb, input clk, rst_ni);

endinterface
