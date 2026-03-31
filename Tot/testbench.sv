module testbench;

//    `include "generator_in.sv"

    bit clk;
    bit rst_ni;

    always #5 clk = ~clk;

    initial begin
        rst_ni = 0;
        #15 rst_ni = 1;
    end

    in_interface in_intf(clk, rst_ni);
    out_interface out_intf(clk, rst_ni);

    default_test t1(in_intf, out_intf);
 switch DUT (
 .rst_ni    (in_intf.rst_ni),
 .clk_i     (in_intf.clk),
 .valid_i   (in_intf.valid_i),
 .data_i    (in_intf.data_i),
 .ready_o   (in_intf.ready_o),
 .valid_o   (out_intf.valid_o),
 .ready_i   (out_intf.ready_i), 
 .data_o    (out_intf.data_o)
 );
   

    initial begin 
        $dumpfile("dump.vcd"); $dumpvars;
    end

endmodule