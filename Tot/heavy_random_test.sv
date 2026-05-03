`include "transaction_in.sv"
`include "environment.sv"

// Extindem clasa de tranzactie pentru a rescrie constrangerile de delay
class heavy_trans extends transaction_in;
    // Suprascriem constrangerea delay_constr pentru a permite pauze mai mari (pana la 100)
    // Asta va lovi si ultimul bin "huge_delay" din coverage_in.
    constraint delay_constr { soft delay inside {[0:100]}; }
endclass

program heavy_random_test(
    in_interface in_intf,
    out_interface out_intf_0,
    out_interface out_intf_1,
    out_interface out_intf_2,
    out_interface out_intf_3
);

    environment env;
    heavy_trans h_trans;

    initial begin
        // Instantiem mediul
        env = new(in_intf, out_intf_0, out_intf_1, out_intf_2, out_intf_3);
        
        // Cream tranzactia cu noile constrangeri
        h_trans = new();
        
        // Suprascriem tranzactia default din generator cu tranzactia noastra
        env.gen_i.trans = h_trans;
        
        // Generam un numar masiv de pachete (5000) pentru a atinge 100% coverage
        env.gen_i.trans_ct = 5000;
        
        // Optional, generatorul de iesire poate ramane la configuratia default (0)
        // Switch-ul isi face treaba doar in functie de intrare
        env.gen_o_0.trans_ct = 5000;
        env.gen_o_1.trans_ct = 5000;
        env.gen_o_2.trans_ct = 5000;
        env.gen_o_3.trans_ct = 5000;
        
        // Pornim executia
        env.run();
    end

endprogram
