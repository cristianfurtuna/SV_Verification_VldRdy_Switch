//scoreboardul preia datele de la monitor si verifica acuratetea acestora; pentru a se
// face aceasta verificare, in scoreboard este implementata functionalitatea DUT-ului;
// intrarile pe care le primeste DUT-ul sunt preluate de catre monitor si transmise
// scoreboardului; comparandu-se iesirile monitorului si ale scoreboardului se poate 
//determina daca acestea functioneaza corect
class scoreboard;
//mailbox monitor intrare
mailbox mon_in2scb;
//mailbox-uri pentru iesire, 4 canale
mailbox mon_out2scb_0, mon_out2scb_1, mon_out2scb_2, mon_out2scb_3;
//datele asteptate pe fiecare canal vor fi stocate in cozi
//folosesc transaction in deoarece contine si adresa destinatie
transaction_in items_expected [4][$];

int no_transactions;

//Constructor mailbox-uri
function new(mailbox mon_in2scb, mailbox mon_out2scb_0, mailbox mon_out2scb_1,
mailbox mon_out2scb_2, mailbox mon_out2scb_3);
    this.mon_in2scb = mon_in2scb;
    this.mon_out2scb_0 = mon_out2scb_0;
    this.mon_out2scb_1 = mon_out2scb_1;
    this.mon_out2scb_2 = mon_out2scb_2;
    this.mon_out2scb_3 = mon_out2scb_3;
endfunction

//task principal
task main;
    fork
        //colectam tot ce intra si prezicem unde trebuie sa ajunga
        collect_input();
        
        //verificam fiecare canal de iesire in paralel
        check_port(0, mon_out2scb_0);
        check_port(1, mon_out2scb_1);
        check_port(2, mon_out2scb_2);
        check_port(3, mon_out2scb_3);
    join
endtask

//citim datele de la intrare si punem pachetul in coada corespunzatoare adresei
task collect_input;
    forever begin
        transaction_in tr;
        mon_in2scb.get(tr);
        items_expected[tr.address].push_back(tr); 
        $display("%0t [SCB-LOG] Pachet salvat pentru Canal %0d (Data: %h)", $time, tr.address, tr.data_i);
    end
endtask

function check_fifos_are_empty();
transaction_in trans_aux;
    for (int i = 0; i<4;i++)
    assert (items_expected[i].size() == 0)
    else begin $error("%0t pe canalul %0d, nu au iesit toate datele care trebuiau sa iasa, deoarece mai sunt %0d elemente", $time, i, items_expected[i].size());
    $display("unul din elementele in plus este:");
    trans_aux = items_expected[i].pop_front();
    trans_aux.display();
    end
endfunction

//verificare canale
task check_port(int channel, mailbox mon_out2scb);
    forever begin
        transaction_out tr_actual;
        transaction_in tr_expected;
        mon_out2scb.get(tr_actual); //asteptam pachetul de la monitor
        if(items_expected[channel].size() > 0) begin
            tr_expected = items_expected[channel].pop_front(); //luam primul pachet asteptat
            
            if(tr_actual.data_o == tr_expected.data_i) begin
                $display("%0t [SCB-PASS] Canal %0d | Expected: %h, Actual: %h", $time, channel, tr_expected.data_i, tr_actual.data_o);
            end else begin
                $error("%0t [SCB-FAIL] Canal %0d | Expected: %h, Actual: %h", $time, channel, tr_expected.data_i, tr_actual.data_o);
            end
        end else begin
            $error("%0t [SCB-UNEXPECTED] Canal %0d a scos date (%h) dar nu era nimic asteptat!", $time, channel, tr_actual.data_o);
        end
        no_transactions++;        
    end
endtask                
               
endclass 