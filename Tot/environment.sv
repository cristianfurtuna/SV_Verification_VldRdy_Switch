class environment;
//    `include "transaction_in.sv"
//    `include "transaction_out.sv"
//    `include "generator_in.sv"
//    `include "generator_out.sv"
//    `include "driver_out.sv"
//    `include "driver_in.sv"
    generator_in    gen_i;
    driver_in       driv_i;
    
    generator_out   gen_o_0, gen_o_1, gen_o_2, gen_o_3;
    driver_out      driv_o_0, driv_o_1, driv_o_2, driv_o_3;
        
    // monitor_in      mon_in;
    // monitor_out     mon_out;
    // scoreboard      scb;

    mailbox input_gen2driv;
    mailbox output_gen2driv_0;
    mailbox output_gen2driv_1;
    mailbox output_gen2driv_2;
    mailbox output_gen2driv_3;
    // mailbox mon_in2scb;
    // mailbox mon_out2scb;

    virtual in_interface in_vif;
    virtual out_interface out_vif;

    function new(virtual in_interface in_vif, virtual out_interface out_vif);

        this.in_vif = in_vif;
        this.out_vif = out_vif;

        input_gen2driv       = new();
        output_gen2driv_0    = new();
        output_gen2driv_1    = new();
        output_gen2driv_2    = new();
        output_gen2driv_3    = new();
        // mon_in2scb  = new();
        // mon_out2scb = new();

        gen_i        = new(input_gen2driv);
        driv_i       = new(in_vif,  input_gen2driv);
        gen_o_0      = new(output_gen2driv_0);
        gen_o_1      = new(output_gen2driv_1);
        gen_o_2      = new(output_gen2driv_2);
        gen_o_3      = new(output_gen2driv_3);
        driv_o_0     = new(out_vif, output_gen2driv_0);
        driv_o_1     = new(out_vif, output_gen2driv_1);
        driv_o_2     = new(out_vif, output_gen2driv_2);
        driv_o_3     = new(out_vif, output_gen2driv_3);
        
        // mon_in  = new(in_vif,  mon_in2scb);
        // mon_out = new(out_vif, mon_out2scb);
        // scb     = new(mon_in2scb, mon_out2scb);

    endfunction

    task pre_test();
        begin
            fork
                driv_i.reset();
                driv_o_0.reset();
                driv_o_1.reset();
                driv_o_2.reset();
                driv_o_3.reset();
            join
        end
    endtask

    task test();
        fork 
            gen_i.main();
            driv_i.main();
            gen_o_0.main();
            gen_o_1.main();
            gen_o_2.main();
            gen_o_3.main();
            driv_o_0.main();
            driv_o_1.main();
            driv_o_2.main();
            driv_o_3.main();
            // mon.main();
            // scb.main();  
            begin
                #4000;
                report();
                $stop;
            end    
        join
    endtask

    function report();
        // scb.colector_coverage.print_coverage();
    endfunction

    task run;
        pre_test();
        test();
        $finish;
    endtask

endclass
