class generator_out; //identic cu generator_in din punct de vedere al codului

//clasa contine doua atribute de tipul "transaction"
rand transaction_out trans, tr;

//trans_ct arata numarul de tranzactii care vor fi generate
int trans_ct;

mailbox gen2driv;


//constructor
function new(mailbox gen2driv);
//getting the mailbox handle from env, in order to share the transaction packet between the generator and driver, the same mailbox is shared between both.
	this.gen2driv = gen2driv;
    trans		  = new();
endfunction

//generatorul aleatorizeaza si transmite spre exterior prin "portul" de tip mailbox continutul tranzactiilor (al caror numar este egal cu repeat_count)
//main task, generates(create and randomizes) the trans_ct number of transaction packets and puts into mailbox
//in SystemVerilog task consuma tacte de ceas spre deosebire de function care nu consuma tacte de ceas

task main();
	repeat(trans_ct) begin
		if( !trans.randomize() )
			$fatal("Out_Gen:: trans randomization failed");
			
		tr = trans.do_copy();
		gen2driv.put(tr);
	end	
endtask

//-> ended se ignora

endclass