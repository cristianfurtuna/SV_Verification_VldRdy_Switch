`include "transaction_in.sv"
`include "environment.sv"

// Extindem clasa de tranzactie pentru a forta pauza dintre pachete la 0
class burst_trans extends transaction_in;
    // Fortam delay = 0 pentru a genera trafic "Back to Back"
    constraint delay_constr { delay == 0; }
endclass

program burst_test(
    in_interface in_intf,
    out_interface out_intf_0,
    out_interface out_intf_1,
    out_interface out_intf_2,
    out_interface out_intf_3
);

    environment env;
    burst_trans b_trans;

    initial begin
        // Instantiem mediul
        env = new(in_intf, out_intf_0, out_intf_1, out_intf_2, out_intf_3);
        
        // Cream tranzactia "burst"
        b_trans = new();
        
        // O atribuim generatorului
        env.gen_i.trans = b_trans;
        
        // Generam un numar de pachete consecutive (ex. 100)
        env.gen_i.trans_ct = 100;
        
        env.gen_o_0.trans_ct = 100;
        env.gen_o_1.trans_ct = 100;
        env.gen_o_2.trans_ct = 100;
        env.gen_o_3.trans_ct = 100;
        
        // Pornim executia
        env.run();
    end

endprogram
