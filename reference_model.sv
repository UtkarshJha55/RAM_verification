// Reference model mimics the functioning of DUT. It takes data from write and read monitors using get method and sends the output to scoreboard using put method
class reference_model;
    transaction data_rd, data_wrt;
    logic [31:0] ref_data [int];
    mailbox #(transaction) wr_mon_ref_mdl;
    mailbox #(transaction) rd_mon_ref_mdl;
    mailbox #(transaction) ref_mdl_sb;

    function new(mailbox #(transaction) wr_mon_ref_mdl,
                 mailbox #(transaction) rd_mon_ref_mdl,
                 mailbox #(transaction) ref_mdl_sb);
        this.wr_mon_ref_mdl = wr_mon_ref_mdl;
        this.rd_mon_ref_mdl = rd_mon_ref_mdl;
        this.ref_mdl_sb = ref_mdl_sb;
    endfunction

    task mem_write(transaction t);
        if (t.write_enable)
            ref_data[t.write_address] = t.data_in;
    endtask

    task mem_read(transaction t);
        if (t.read_enable)
            t.data_out = ref_data[t.read_address];
    endtask

    task start();
        fork
            forever begin wr_mon_ref_mdl.get(data_wrt); mem_write(data_wrt); end
            forever begin rd_mon_ref_mdl.get(data_rd); mem_read(data_rd); ref_mdl_sb.put(data_rd); end
        join_none;
    endtask
endclass
