//aici se declara tipul de data folosit pentru a stoca datele vehiculate intre generator si driver; monitorul, de asemenea, preia datele de pe interfata, le recompune folosind un obiect al acestui tip de data, si numai apoi le proceseaza
class transaction_out;

	 bit [7:0] data_o;  //iesire deci nu necesita rand
	 
	 int trans_no;      //numarator tranzactii ; int e mai usor pentru ca accepta si valori foarte mari
rand int delay;         //delay intre tranzactii (pe iesire, complica monitorul), de asemenea nu mai putem sa ii dam constraint
rand int duration_of_transaction;         //delay intre tranzactii (pe iesire, complica monitorul), de asemenea nu mai putem sa ii dam constraint

//constrangeri
constraint delay_c {delay inside {[0:200]};}
constraint duration_c {duration_of_transaction inside {[1:50]};}

//aceasta functie afiseaza valorile randomizate ale atributelor clasei
function void display();
	$display("---------Tranzactia nr. :%0d ---------", trans_no);
	
	$display(" trans_no = %0h ", trans_no);  //%0 sterge spatiul extra
	$display(" data_o = %0h ", data_o);
	$display(" delay = %0d ", delay);
	$display(" duration_of_transasction = %0d ", duration_of_transaction);
	
	$display("---------------------------------------------");
endfunction

//copiezi tranzactii (copierea unui obiect in alt obiect)
function transaction_out do_copy();
	transaction_out new_trans;
	new_trans                         = new();
	new_trans.trans_no                 = this.trans_no;
	new_trans.data_o                  = this.data_o;
	new_trans.delay                   = this.delay;
	new_trans.duration_of_transaction = this.duration_of_transaction;
	return new_trans;
endfunction





endclass