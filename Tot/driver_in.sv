//driverul preia datele de la generator, la nivel abstract, si le trimite DUT-ului conform protocolului de comunicatie pe interfata respectiva
//gets the packet from generator and drive the transaction paket items into interface (interface is connected to DUT, so the items driven into interface signal will get driven in to DUT) 

//se declara macro-ul DRIV_IF care va reprezenta interfata pe care driverul va trimite date DUT-ului
//`define DRIV_IF in_vif.DRIVER.driver_cb

class driver_in;

int no_transactions;

virtual in_interface in_vif;

mailbox gen2driv;

function new(virtual in_interface in_vif, mailbox gen2driv);
	this.in_vif = in_vif;
	this.gen2driv = gen2driv;
endfunction

//resetam input-urile

task reset;
	@(in_vif.rst_ni ==0);//asteptam activarea resetului
	in_vif.DRIVER.drv_cb.valid_i <= 0;
	in_vif.DRIVER.drv_cb.data_i  <= 0;  //ne legam prin modport
	//asteptand dupa posedge ne-ar strica logica la thread-uri
endtask

task driving;
	//preluam tranzactia din mailbox
	transaction_in trans;
	gen2driv.get(trans);
	
	$display("%0t--------- [DRIVER-STARTED: %0d] ---------",$time,  no_transactions);
	
	repeat(trans.delay)	@(posedge in_vif.clk);
	
	in_vif.DRIVER.drv_cb.valid_i <= trans.valid_i;
	in_vif.DRIVER.drv_cb.data_i[7:0]  <= trans.data_i;
	in_vif.DRIVER.drv_cb.data_i[9:8]  <= trans.address;
	
	@(posedge in_vif.clk iff in_vif.DRIVER.drv_cb.ready_o);// numai dupa finalizarea tranzactiei protocolul permite punerea semnalului valid in 0 si modificarea datelor
	in_vif.DRIVER.drv_cb.valid_i <= 0;
	in_vif.DRIVER.drv_cb.data_i  <= 0;
	
	no_transactions++;
endtask

task main;
	forever begin
		while (in_vif.rst_ni == 0)//se asteapta dezactivarea restului
			@(posedge in_vif.clk);
		
		fork
			begin
				reset(); //Asteapta reset
			end
		
			begin
				driving(); //Driving de pachete
			end
		join_any
		disable fork;
		// reset();
	end
endtask

endclass
