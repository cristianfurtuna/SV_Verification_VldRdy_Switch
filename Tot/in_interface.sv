interface in_interface(input logic clk, rst_ni);
    logic [9:0] data_i;
    logic valid_i;
    logic ready_o;
    

    //clocking block for driver 
    clocking drv_cb @(posedge clk);
	    //semnalele de intrare sunt citite o unitate de timp inainte frontului de ceas, iar semnalele de iesire sunt citite o unitate de timp dupa frontul de ceas; astfel se elimina situatiile in care se fac scrieri sau citiri in acelasi timp
    default input #1 output #1;
        output data_i;
        output valid_i;
        input ready_o;
    endclocking

    //clocking block for monitor    
    clocking mon_cb @(posedge clk);
	    //semnalele de intrare sunt citite o unitate de timp inainte frontului de ceas, iar semnalele de iesire sunt citite o unitate de timp dupa frontul de ceas; astfel se elimina situatiile in care se fac scrieri sau citiri in acelasi timp
    default input #1 output #1;
        input data_i;
        input valid_i;
        input ready_o;
    endclocking


// driver modport
modport DRIVER (clocking drv_cb, input clk, rst_ni);

// monitor modport
modport MONITOR (clocking mon_cb, input clk, rst_ni);

// asertii

endinterface