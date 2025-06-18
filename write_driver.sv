// Driver used for write operation. It takes the transaction data and writes it into driver interface through modport instance. 
// It happens using get method of mailbox (receives transaction from generator) 
 
class write_driver;
    virtual ram_itfc.WR_DRV_MDPT wr_driver_if;
    transaction data_design;
    mailbox #(transaction) gen_wr_drvr_rcv;

    function new(virtual ram_itfc.WR_DRV_MDPT wr_driver_if,
                 mailbox #(transaction) gen_wr_drvr_rcv);
        this.wr_driver_if = wr_driver_if;
        this.gen_wr_drvr_rcv = gen_wr_drvr_rcv;
        data_design = new();
    endfunction

    task drive();
        @(wr_driver_if.write_driver_cb);
        wr_driver_if.write_driver_cb.data_in <= data_design.data_in;
        wr_driver_if.write_driver_cb.write_address <= data_design.write_address;
        wr_driver_if.write_driver_cb.write_enable <= data_design.write_enable;
    endtask

    task start();
        fork
            forever begin
                gen_wr_drvr_rcv.get(data_design);
                drive();
            end
        join_none;
    endtask
endclass
