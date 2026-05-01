
constraint transaction_in::big_delays_c {delay inside {[50:100]};}

program default_test(
    in_interface in_intf,
    out_interface out_intf_0,
    out_interface out_intf_1,
    out_interface out_intf_2,
    out_interface out_intf_3
);

    environment env;

    initial begin
        env = new(in_intf, out_intf_0, out_intf_1, out_intf_2, out_intf_3);
        env.gen_i.trans_ct = 10;
        //env.gen_i.single_transaction(8'hFF, 2'b11);
        env.gen_o_0.trans_ct = 10;
        env.gen_o_1.trans_ct = 10;
        env.gen_o_2.trans_ct = 10;
        env.gen_o_3.trans_ct = 10;
        env.run();
    end

endprogram