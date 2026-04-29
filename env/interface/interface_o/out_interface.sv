interface out_interface (input logic clk, rst_ni);

logic valid_o;
logic [7:0] data_o;
logic ready_i;

//clocking block pentru driving
clocking drv_cb @(posedge clk);
	default input #1 output #1;
	input 		 valid_o;
	input        data_o;
	output 		 ready_i;
endclocking

//clocking block pentru monitor
clocking mon_cb @(posedge clk);
	default input #1 output #1;
	input        valid_o;
	input        data_o;
	input        ready_i;
endclocking

//driver modport
modport DRIVER (clocking drv_cb, input clk, rst_ni);

//monitor modport
modport MONITOR (clocking mon_cb, input clk, rst_ni);

//-----asertii pentru interfata de iesire-----

//datele trebuie mentinute stabile pe toata durata unei cereri (valid = 1 si rdy = 0)
property stable_data;
	@(posedge clk) disable iff (~rst_ni) //daca avem reset, nu se executa asertia
	(valid_o && !ready_i) |=> $stable(data_o); //necesita "|=>" deoarece functia stable verifica daca data nu s-a schimbat fata de tactul anterior
endproperty

asertia_stable_data: assert property (stable_data)
else $error("%0t INTERFATA_IESIRE: a picat asertia asertia_stable_data", $time);
STABLE_DATA: cover property (stable_data); //ne asiguram ca proprietatea a fost accesata macar o singura data

//odata activ, valid nu poate fi retras inainte ca ready sa fie 1
property valid_fall;
	@(posedge clk) disable iff (~rst_ni)
	$fell (valid_o) |-> $past(ready_i); //se poate simplifica, se considera valid_o ca fiind deja activ
endproperty

asertia_valid_fall: assert property (valid_fall)
else $error("%0t INTERFATA_IESIRE: a picat asertia valid_fall", $time);
VALID_FALL: cover property (valid_fall);

//trebuie evitate valorile de date nedeterminate cat timp valid este sus
property correct_data;
	@(posedge clk) disable iff (~rst_ni)
	valid_o |-> !$isunknown(data_o);
endproperty

asertia_correct_data: assert property (correct_data)
else $error("%0t INTERFATA_IESIRE: a picat asertia correct_data", $time);
CORRECT_DATA: cover property (correct_data);

endinterface
