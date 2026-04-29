//monitorul urmareste traficul de pe interfetele DUT-ului, preia datele verificate si recompune tranzactiile 
//(folosind obiecte ale clasei transaction); in implementarea de fata, datele preluate de pe interfete sunt trimise scoreboardului pentru verificare
//Samples the interface signals, captures into transaction packet and send the packet to scoreboard.

`define MON_IF out_vif.MONITOR.mon_cb
class monitor_out;

//creating virtual interface handle
virtual out_interface out_vif;

string name;
//se creaza portul prin care monitorul trimite scoreboardului datele colectate de pe interfata DUT-ului sub forma de tranzactii 
//creating mailbox handle
mailbox mon2scb;
coverage_out coverage_collector;


//variabila pentru masurarea delay-ului dintre tranzactii
int current_delay = 0;

//cand se creaza obiectul de tip monitor (in fisierul environment.sv), interfata de pe care acesta colecteaza date este conectata la interfata reala a DUT-ului
//constructor
	function new(virtual out_interface out_vif, mailbox mon2scb, string name);
		//getting the interface
		this.out_vif = out_vif;
		//getting the mailbox handle from environment
		this.mon2scb = mon2scb;
		
		this.name = name;
		
		coverage_collector = new(name);
	endfunction
	
task main;
    forever begin
    //se declara si se creeaza obiectul de tip tranzactie care va contine
    //datele preluate de pe interfata
    transaction_out trans;
    //datele sunt citite pe frontul de ceas, informatiile preluate de pe
    //semnale fiind retinute in obiectul de tip tranzactie
    @(posedge out_vif.MONITOR.clk);
    //daca avem handshake valid pe canalul corespunzator ID-ului
    if(`MON_IF.valid_o && `MON_IF.ready_i) begin
        trans = new(); //se creaza un obiect de tip tranzactie pentru datele capturate
        trans.data_o = `MON_IF.data_o; // colectam datele de pe canal
        trans.delay = current_delay; //retinem delay-ul masurat
        
        //afisam in consola ce am capturat
        $display("%0t [MONITOR_OUT_%s] Pachet detectat: Data = %h, Delay = %0d", $time, name, trans.data_o, trans.delay);
        
        //apel coverage
        coverage_collector.sample_function(trans);
        
        //trimitem tranzactia catre scoreboard
        mon2scb.put(trans);
        
        //resetam contorul de la delay pentru tranzactia urmatoare
        current_delay = 0;
        
        //asteptam sa se termine handshake-ul curent pentru a nu citi
        //acelasi pachet de mai multe ori
        wait(`MON_IF.valid_o == 0 || `MON_IF.ready_i == 0);
    end
      else begin
        //daca nu avem transfer valid, incrementam delay-ul
        current_delay++;
     end
    end         
endtask        
        
endclass 