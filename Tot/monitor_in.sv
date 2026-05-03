//monitorul urmareste traficul de pe interfetele DUT-ului, preia datele verificate si recompune tranzactiile 
//(folosind obiecte ale clasei transaction); in implementarea de fata, datele preluate de pe interfete sunt trimise scoreboardului pentru verificare
//Samples the interface signals, captures into transaction packet and send the packet to scoreboard.

`include "coverage_in.sv"

`define MON_IN_IF in_vif.MONITOR.mon_cb
class monitor_in;

//creating virtual interface handle
virtual in_interface in_vif;

string name;
//se creaza portul prin care monitorul trimite scoreboardului datele colectate de pe interfata DUT-ului sub forma de tranzactii 
//creating mailbox handle
mailbox mon2scb;
coverage_in coverage_collector;


//variabila pentru masurarea delay-ului dintre tranzactii
int current_delay = 0;

//cand se creaza obiectul de tip monitor (in fisierul environment.sv), interfata de pe care acesta colecteaza date este conectata la interfata reala a DUT-ului
//constructor
	function new(virtual in_interface in_vif, mailbox mon2scb, string name);
		//getting the interface
		this.in_vif = in_vif;
		//getting the mailbox handle from environment
		this.mon2scb = mon2scb;
		
		this.name = name;
		
		coverage_collector = new(name);
	endfunction
	
task main;
    forever begin
        //se declara si se creeaza obiectul de tip tranzactie care va contine
        //datele preluate de pe interfata
        transaction_in trans;
        //datele sunt citite pe frontul de ceas, informatiile preluate de pe
        //semnale fiind retinute in obiectul de tip tranzactie
        @(posedge in_vif.MONITOR.clk);
        //daca avem handshake valid pe canalul corespunzator ID-ului
        if(`MON_IN_IF.valid_i == 1 && `MON_IN_IF.ready_o == 1) begin
            trans = new(); //se creaza un obiect de tip tranzactie pentru datele capturate
            trans.data_i = `MON_IN_IF.data_i[7:0]; // colectam datele de pe canal
            trans.address = `MON_IN_IF.data_i[9:8]; // colectam datele de pe canal
            trans.delay = current_delay; //retinem delay-ul masurat
            
            //afisam in consola ce am capturat
            $display("%0t [MONITOR_IN_%s] Pachet detectat: Data = %h, Delay = %0d", $time, name, trans.data_i, trans.delay);
            
            //apel coverage
            coverage_collector.sample_function(trans);
            
            //trimitem tranzactia catre scoreboard
            mon2scb.put(trans);
            
            //resetam contorul de la delay pentru tranzactia urmatoare
            current_delay = 0;
        end
        else begin
            //daca nu avem transfer valid, incrementam delay-ul
            current_delay++;
        end
    end         
endtask        
        
endclass 