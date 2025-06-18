// Monitor for write operations. It collects the input values required for DUT, and passes it to reference model through write modport interface and put method of mailbox.
// The data which is passed to reference model, is received from write driver through virtual interface connected with DUT
class write_monitor;
    virtual ram_itfc.WR_MNTR_MDPT wr_mon_if;
    transaction data_ref_model;
    mailbox #(transaction) monitor_wrt_mntr;

    function new(virtual ram_itfc.WR_MNTR_MDPT wr_mon_if,
                 mailbox #(transaction) monitor_wrt_mntr);
        this.wr_mon_if = wr_mon_if;
        this.monitor_wrt_mntr = monitor_wrt_mntr;
        data_ref_model = new();
    endfunction

    task monitor();
        @(wr_mon_if.write_monitor_cb);
        if (wr_mon_if.write_monitor_cb.write_enable) begin
            data_ref_model.write_enable = 1;
            data_ref_model.write_address = wr_mon_if.write_monitor_cb.write_address;
            data_ref_model.data_in = wr_mon_if.write_monitor_cb.data_in;
            monitor_wrt_mntr.put(data_ref_model);
        end
    endtask

    task start();
        fork forever monitor(); join_none;
    endtask
endclass
