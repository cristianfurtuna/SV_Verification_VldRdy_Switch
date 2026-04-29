class generator_in;

//clasa contine doua atribute de tipul "transaction"
rand transaction_in trans, tr;

//trans_ct arata numarul de tranzactii care vor fi generate
int trans_ct;

mailbox gen2driv;

//mailbox gen2scb; //adaugat pt scb


//constructor
function new(mailbox gen2driv/*, mailbox gen2scb*/);
//getting the mailbox handle from env, in order to share the transaction packet between the generator and driver, the same mailbox is shared between both.
	this.gen2driv = gen2driv;
	//this.gen2scb  = gen2scb;
    trans		  = new();
endfunction

//generatorul aleatorizeaza si transmite spre exterior prin "portul" de tip mailbox continutul tranzactiilor (al caror numar este egal cu repeat_count)
//main task, generates(create and randomizes) the trans_ct number of transaction packets and puts into mailbox
//in SystemVerilog task consuma tacte de ceas spre deosebire de function care nu consuma tacte de ceas

task main();
	repeat(trans_ct) begin
		if( !trans.randomize() )
			$fatal("In_Gen:: trans randomization failed");
			
		tr = trans.do_copy(); //copia se face pentru a transmite tranzactii separate la adrese noi de memorie (similar pointer)
		gen2driv.put(tr);
		//gen2scb.put(tr);
	end	
endtask

task single_transaction(bit[7:0] data, bit [1:0] addr);

		if( !trans.randomize() with {data_i == data; address == addr;})
			$fatal("In_Gen:: trans randomization failed");
			
		tr = trans.do_copy(); //copia se face pentru a transmite tranzactii separate la adrese noi de memorie (similar pointer)
		gen2driv.put(tr);
		//gen2scb.put(tr);
	
endtask

//-> ended se ignora
//ended eveniment pe baza caruia putem sa sincronizam anumite actiuni in mediul de verificare

endclass

