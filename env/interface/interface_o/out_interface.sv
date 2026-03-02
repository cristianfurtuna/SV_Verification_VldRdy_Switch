interface out_interface (input logic clk, rst)

    logic            valid_o;
    logic   [9 : 0]  data_o;
    logic            ready_i;

    //clocking block for the driver
    clocking drv_cb @ (posedge clk);
            input  valid_o;
            input  data_o;
            output ready_i;
    endclocking

    //clocking block for the monitor
    clocking mon_cb @ (posedge clk);
            input valid_o;
            input data_o;
            input ready_i;
    endclocking
endinterface