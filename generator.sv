// It generates the transactions required for DUT using mailbox and instances.
// Mailboxes are created and takes both write and read operations (separate) as put, to be send to respective drivers.
class generator;
    transaction txn_obj, txndata;
    mailbox #(transaction) gen_wrt_drvr;
    mailbox #(transaction) gen_rd_drvr;
    int txn_num;

    function new(mailbox #(transaction) gen_wrt_drvr,
                 mailbox #(transaction) gen_rd_drvr,
                 int txn_num);
        this.gen_wrt_drvr = gen_wrt_drvr;
        this.gen_rd_drvr  = gen_rd_drvr;
        this.txn_num      = txn_num;
        txn_obj = new();
    endfunction

    task run();
        for (int i = 0; i < txn_num; i++) begin
          assert(txn_obj.randomize);
          txndata = new txn_obj;
            if (txndata.write_enable)
                gen_wrt_drvr.put(txndata);
            if (txndata.read_enable)
                gen_rd_drvr.put(txndata);
        end
    endtask
endclass
