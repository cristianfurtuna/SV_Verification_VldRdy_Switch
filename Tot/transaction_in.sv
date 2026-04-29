//aici se declara tipul de data folosit pentru a stoca datele vehiculate intre generator si driver; monitorul, de asemenea, preia datele de pe interfata, le recompune folosind un obiect al acestui tip de data, si numai apoi le proceseaza
`ifndef transaction_in
`define transaction_in

class transaction_in;


rand bit 	   valid_i;
rand bit [7:0] data_i;
rand bit [9:8] address;
	 
	 int trans_no;      //numarator tranzactii ; int e mai usor pentru ca accepta si valori foarte mari
rand int delay;         //delay intre tranzactii

//constrangeri
//constraint delay_constr { delay >= 0 && delay < 10; }; //ne asiguram ca delay-ul dintre tranzactii nu este prea mare
constraint delay_constr { delay inside {[0:200]};}; //ne asiguram ca avem delay intr-o plaja mai mare de valori --Denis
constraint valid_constr { soft valid_i == 1'b1; }; //soft ne permite sa suprascriem constraint-ul
constraint addr_constr  { address inside {[0:3]};}; //ne asiguram ca fiecare canal primeste date --Denis  
constraint data_constr  { data_i inside {[0:255]};}; //ne asiguram ca data acopera toata plaja de valori --Denis


//aceasta functie afiseaza valorile randomizate ale atributelor clasei
function void display();
	$display("---------Tranzactia nr. :%0d ---------", trans_no);
	
	$display(" valid_i = %0h ", valid_i);  //%0 sterge spatiul extra
	$display(" data_i = %0h ", data_i);
	$display(" delay = %0d ", delay);
	$display(" address = %0h ", address);
	
	$display("---------------------------------------------");
endfunction

//copiezi tranzactii (copierea unui obiect in alt obiect)
function transaction_in do_copy();
	transaction_in new_trans;
	new_trans = new();
	new_trans.valid_i = this.valid_i;
	new_trans.data_i  = this.data_i;
	new_trans.delay   = this.delay;
	new_trans.address = this.address;
	return new_trans;
endfunction


endclass

`endif