module testbench;

    `include "generator_in.sv"

    bit clk;
    bit rst_ni;

    always #5 clk = ~clk;

    initial begin
        rst_ni = 0;
        #15 rst_ni = 1;
       // #15 rst_ni = 0;
       // #15 rst_ni = 1;
       // #15 rst_ni = 0;
      //  #15 rst_ni = 1;
       // #15 rst_ni = 0;
       // #15 rst_ni = 1;
       // #15 rst_ni = 0;
       // #15 rst_ni = 1;
    end

    in_interface in_intf(clk, rst_ni);
    out_interface out_intf_0(clk, rst_ni);
    out_interface out_intf_1(clk, rst_ni);
    out_interface out_intf_2(clk, rst_ni);
    out_interface out_intf_3(clk, rst_ni);

    default_test t1(in_intf, out_intf_0, out_intf_1, out_intf_2, out_intf_3);
    //date_1_canal t2(in_intf, out_intf_0, out_intf_1, out_intf_2, out_intf_3);
    //delay_mare_in_test t3(in_intf, out_intf_0, out_intf_1, out_intf_2, out_intf_3);
 switch DUT (
 .rst_ni    (in_intf.rst_ni),
 .clk_i     (in_intf.clk),
 .valid_i   (in_intf.valid_i),
 .data_i    (in_intf.data_i),
 .ready_o   (in_intf.ready_o),
 .valid_o   ({out_intf_3.valid_o, out_intf_2.valid_o, out_intf_1.valid_o, out_intf_0.valid_o}),
 .ready_i   ({out_intf_3.ready_i, out_intf_2.ready_i, out_intf_1.ready_i, out_intf_0.ready_i}), 
 .data_o    ({out_intf_3.data_o, out_intf_2.data_o, out_intf_1.data_o, out_intf_0.data_o})
 );
 
 
    initial begin 
        $dumpfile("dump.vcd"); $dumpvars;
    end

endmodule