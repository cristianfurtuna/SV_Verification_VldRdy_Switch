
program default_test(in_interface in_intf, out_interface out_intf);

    environment env;

    initial begin
        env = new(in_intf, out_intf);
        env.gen_i.trans_ct = 8;
        env.gen_o_0.trans_ct = 8;
        env.gen_o_1.trans_ct = 8;
        env.gen_o_2.trans_ct = 8;
        env.gen_o_3.trans_ct = 8;
        env.run();
    end

endprogram