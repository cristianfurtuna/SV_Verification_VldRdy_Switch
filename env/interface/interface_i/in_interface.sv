interface in_interface (input logic clk, rst);
    
    logic            valid_i;
    logic   [9 : 0]  data_i;
    logic            ready_o;

    //clocking block for the driver
    clocking drv_cb @ (posedge clk);
            output valid_i;
            output data_i;
            input  ready_o;
    endclocking

    //clocking block for the monitor
    clocking mon_cb @ (posedge clk);
            input valid_i;
            input data_i;
            input ready_o;
    endclocking
endinterface //
