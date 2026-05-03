`ifndef ENVIRONMENT_SV
`define ENVIRONMENT_SV

class environment;
   // `include "transaction_in.sv"
  //  `include "transaction_out.sv"
   // `include "generator_in.sv"
   // `include "generator_out.sv"
  //  `include "driver_in.sv"
   // `include "driver_out.sv"
    generator_in    gen_i;
    driver_in       driv_i;
    
    generator_out   gen_o_0, gen_o_1, gen_o_2, gen_o_3;
    driver_out      driv_o_0, driv_o_1, driv_o_2, driv_o_3;
        
    monitor_in      mon_in;
    monitor_out     mon_o_0, mon_o_1, mon_o_2, mon_o_3;
    scoreboard      scb;

    mailbox input_gen2driv;
    //mailbox input_gen2scb;
    mailbox output_gen2driv_0;
    mailbox output_gen2driv_1;
    mailbox output_gen2driv_2;
    mailbox output_gen2driv_3;
    mailbox mon_in2scb;
    mailbox mon_out2scb_0;
    mailbox mon_out2scb_1;
    mailbox mon_out2scb_2;
    mailbox mon_out2scb_3;

    virtual in_interface in_vif;
    virtual out_interface out_vif_0, out_vif_1, out_vif_2, out_vif_3;

    function new(virtual in_interface in_vif, virtual out_interface out_vif_0,
        virtual out_interface out_vif_1, virtual out_interface out_vif_2, virtual
        out_interface out_vif_3);

        this.in_vif = in_vif;
        this.out_vif_0 = out_vif_0;
        this.out_vif_1 = out_vif_1;
        this.out_vif_2 = out_vif_2;
        this.out_vif_3 = out_vif_3;

        input_gen2driv       = new();
        //input_gen2scb        = new();
        output_gen2driv_0    = new();
        output_gen2driv_1    = new();
        output_gen2driv_2    = new();
        output_gen2driv_3    = new();
        mon_in2scb  = new();
        mon_out2scb_0 = new();
        mon_out2scb_1 = new();
        mon_out2scb_2 = new();
        mon_out2scb_3 = new();

        gen_i        = new(input_gen2driv/*, input_gen2scb*/);
        driv_i       = new(in_vif,  input_gen2driv);
        gen_o_0      = new(output_gen2driv_0);
        gen_o_1      = new(output_gen2driv_1);
        gen_o_2      = new(output_gen2driv_2);
        gen_o_3      = new(output_gen2driv_3);
        driv_o_0     = new(out_vif_0, output_gen2driv_0, "CH_0");
        driv_o_1     = new(out_vif_1, output_gen2driv_1, "CH_1");
        driv_o_2     = new(out_vif_2, output_gen2driv_2, "CH_2");
        driv_o_3     = new(out_vif_3, output_gen2driv_3, "CH_3");
        
        mon_in  = new(in_vif,  mon_in2scb, "IN");
        mon_o_0 = new(out_vif_0, mon_out2scb_0, "CH_0");
        mon_o_1 = new(out_vif_1, mon_out2scb_1, "CH_1");
        mon_o_2 = new(out_vif_2, mon_out2scb_2, "CH_2");
        mon_o_3 = new(out_vif_3, mon_out2scb_3, "CH_3");
       
        scb     = new(mon_in2scb, mon_out2scb_0, mon_out2scb_1, mon_out2scb_2, mon_out2scb_3);

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
            mon_in.main();
            gen_o_0.main();
            gen_o_1.main();
            gen_o_2.main();
            gen_o_3.main();
            driv_o_0.main();
            driv_o_1.main();
            driv_o_2.main();
            driv_o_3.main();
            mon_o_0.main();
            mon_o_1.main();
            mon_o_2.main();
            mon_o_3.main();
            scb.main();  
            begin
                // Asteptam un timp calculat dinamic, bazat pe numarul de tranzactii pe care testul doreste sa le ruleze.
                // Estimam cel mult 1500 de unitati de timp per tranzactie (pentru worst-case delay) + o mica garda de timp la final
                #(gen_i.trans_ct * 1500 + 10000);
                report();
                $stop;
            end    
        join
    endtask

    function void report();
        scb.check_fifos_are_empty();
        $display("\n====================================================");
        $display("          RAPORT FINAL COVERAGE INTRARE");
        $display("====================================================");
        mon_in.coverage_collector.print_coverage();
        $display("\n====================================================");
        $display("          RAPORT FINAL COVERAGE IESIRE");
        $display("====================================================");
        mon_o_0.coverage_collector.print_coverage();
        mon_o_1.coverage_collector.print_coverage();
        mon_o_2.coverage_collector.print_coverage();
        mon_o_3.coverage_collector.print_coverage();
    endfunction

    task run;
        pre_test();
        test();
        $finish;
    endtask

endclass

`endif
