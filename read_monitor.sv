// Monitor for read operation. It fetches the read driver values through interface and pass it to reference model and scoreboard using mailbox
class read_monitor;
    virtual ram_itfc.RD_MNTR_MDPT rd_mon_if;
    transaction data_ref_model;
    mailbox #(transaction) monitor_ref_mdl;
    mailbox #(transaction) monitor_scoreboard;

    function new(virtual ram_itfc.RD_MNTR_MDPT rd_mon_if,
                 mailbox #(transaction) monitor_ref_mdl,
                 mailbox #(transaction) monitor_scoreboard);
        this.rd_mon_if = rd_mon_if;
        this.monitor_ref_mdl = monitor_ref_mdl;
        this.monitor_scoreboard = monitor_scoreboard;
        data_ref_model = new();
    endfunction

    task monitor();
        @(rd_mon_if.read_monitor_cb);
        if (rd_mon_if.read_monitor_cb.read_enable) begin
            data_ref_model.read_enable = 1;
            data_ref_model.read_address = rd_mon_if.read_monitor_cb.read_address;
            data_ref_model.data_out = rd_mon_if.read_monitor_cb.data_out;
            monitor_ref_mdl.put(data_ref_model);
            monitor_scoreboard.put(data_ref_model);
        end
    endtask

    task start();
        fork forever monitor(); join_none;
    endtask
endclass
