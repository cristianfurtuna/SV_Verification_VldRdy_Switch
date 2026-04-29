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
property stable_data_in;
	@(posedge clk) disable iff (rst_ni == 0) //daca avem reset, nu se executa asertia
    (valid_i && !ready_o) |-> $stable(data_i); //se foloseste "|->" deoarece $stable compara valoarea curenta cu cea din tactul anterior
endproperty

asertia_stable_data: assert property (stable_data_in)
else $error("%0t INTERFATA_INTRARE: a picat asertia asertia_stable_data", $time);
STABLE_DATA: cover property (stable_data_in); //ne asiguram ca proprietatea a fost accesata macar o singura data

reg rst_ni_delayed;

always@(posedge clk)
rst_ni_delayed <= rst_ni;

//odata activ, valid nu poate fi retras inainte ca ready sa fie 1
property valid_fall_in;
	@(posedge clk) disable iff (rst_ni == 0 || rst_ni_delayed==0)
	$fell (valid_i) |-> $past(valid_i && ready_o); //se poate simplifica, se considera valid_i ca fiind deja activ
endproperty

asertia_valid_fall: assert property (valid_fall_in)
else $error("%0t INTERFATA_INTRARE: a picat asertia asertia_valid_fall", $time);
VALID_FALL: cover property (valid_fall_in);

//trebuie evitate valorile de data nedeterminate cat timp valid este sus
property correct_data_in;
	@(posedge clk) disable iff (rst_ni == 0)
	valid_i |-> !$isunknown(data_i);
endproperty

asertia_correct_data: assert property (correct_data_in)
else $error("%0t INTERFATA_INTRARE: a picat asertia asertia_correct_data", $time);
CORRECT_DATA: cover property (correct_data_in);

endinterface