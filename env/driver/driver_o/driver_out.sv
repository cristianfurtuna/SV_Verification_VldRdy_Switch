`define OUT_DRIV_IF out_vif.DRIVER.drv_cb

class driver_out;

int no_transactions;

virtual out_interface out_vif;

mailbox gen2driv;

function new(virtual out_interface out_vif, mailbox gen2driv);
	this.out_vif = out_vif;
	this.gen2driv = gen2driv;
endfunction

//resetam input-urile (input-uri in DUT)

task reset;
	@(negedge out_vif.rst_ni);
	out_vif.ready_i <= 0;
	//asteptand dupa posedge ne-ar strica logica la thread-uri
endtask

task driving;
	//preluam tranzactia din mailbox
	transaction_out trans;
	gen2driv.get(trans);
	
	$display("%0t--------- [DRIVER-STARTED: %0d] ---------",$time, no_transactions);
	
	repeat(trans.delay) @(posedge out_vif.clk);
	
	`OUT_DRIV_IF.ready_i <= 1'b1;
	
	repeat(trans.duration_of_transaction)@(posedge out_vif.clk);
	`OUT_DRIV_IF.ready_i <= 0;
	
	no_transactions++;
endtask

task main;
	forever begin
		while (out_vif.rst_ni == 0)
			@(posedge out_vif.clk);
		
		fork
			begin
				reset(); //Asteapta reset
			end
		
			begin
				driving(); //Driving de pachete
			end
		join_any
		disable fork;
	end
endtask

endclass
