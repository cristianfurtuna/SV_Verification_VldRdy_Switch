class coverage_in;

    transaction_in trans_covered;
    string name;

    // Definim grupul de coverage pentru a masura cate tranzactii unice de intrare au fost generate
    covergroup cg_input;
        // per_instance=1 permite afisarea procentului de coverage specific pentru aceasta instanta (util daca ar fi mai multe)
        option.per_instance = 1;
        
        // Punct de coverage pentru datele de intrare (8 biți: valori între 0-255). 
        // Scopul este sa ne asiguram ca am generat atat limitele cat si o gama variata de valori intermediare.
        data_cp: coverpoint trans_covered.data_i {
            bins zero = {0};
            bins max = {255};
            bins low = {[1:85]};
            bins mid = {[86:170]};
            bins high = {[171:254]};
        }
        
        // Punct de coverage pentru adrese. 
        // Verifica daca stimulii generati au vizat toate cele 4 canale de iesire posibile ale switch-ului.
        address_cp: coverpoint trans_covered.address {
            bins ch0 = {0};
            bins ch1 = {1};
            bins ch2 = {2};
            bins ch3 = {3};
        }
        
        // Punct de coverage pentru delay-uri. 
        // Se asigura ca am testat design-ul atat cu pachete consecutive (back-to-back = 0), cat si cu pauze medii sau foarte mari intre ele.
        delay_cp: coverpoint trans_covered.delay {
            bins no_delay = {0};
            bins small_delay = {[1:10]};
            bins med_delay = {[11:30]};
            bins big_delay = {[31:50]};
            bins huge_delay = {[51:100]};
        }
        
        // Cross coverage (produs cartezian) intre adresa si valoarea datelor.
        // Genereaza automat 4 (adrese) x 5 (bins de date) = 20 de combinatii posibile (bins).
        // Ne asigura ca NU doar ca am trimis date pe toate canalele, ci ca am trimis TOATE tipurile de date pe FIECARE canal.
        cross_address_data: cross address_cp, data_cp;
    endgroup

    // Constructor
    function new(string name);
        this.name = name;
        cg_input = new();
        cg_input.option.name = name;
    endfunction

    // Functia de esantionare (sample)
    // Este apelata automat din "monitor_in" de fiecare data cand un pachet valid este preluat de pe interfata.
    // Transmite pachetul (tr) grupului de coverage pentru a inregistra in ce "bin"-uri se incadreaza.
    task sample_function(transaction_in tr);
        this.trans_covered = tr;
        cg_input.sample();
    endtask

    // Functia de afisare a raportului
    function void print_coverage();
        $display("\n--- Coverage Report for Port: %s ---", name);
        $display("Data Coverage    = %.2f%%", cg_input.data_cp.get_inst_coverage());
        $display("Address Coverage = %.2f%%", cg_input.address_cp.get_inst_coverage());
        $display("Delay Coverage   = %.2f%%", cg_input.delay_cp.get_inst_coverage());
        $display("Cross Coverage   = %.2f%%", cg_input.cross_address_data.get_inst_coverage());
        $display("Total Input coverage = %.2f%%", cg_input.get_inst_coverage());
        $display("--------------------------------------");
    endfunction

endclass
