// Driver for read operations. It fetches the transaction data for read operation from RAM. After 3 cycles, read enable is put to 0 for avoiding any data miss
// The data is fetched using get method of mailbox (receiving from generator)
class read_driver;
    virtual ram_itfc.RD_DRV_MDPT rd_drv_if;
    transaction data_dut;
    mailbox #(transaction) gen_read_mntr;

    function new(virtual ram_itfc.RD_DRV_MDPT rd_drv_if,
                 mailbox #(transaction) gen_read_mntr);
        this.rd_drv_if = rd_drv_if;
        this.gen_read_mntr = gen_read_mntr;
    endfunction

    task drive();
        @(rd_drv_if.read_driver_cb);
        rd_drv_if.read_driver_cb.read_enable <= data_dut.read_enable;
        rd_drv_if.read_driver_cb.read_address <= data_dut.read_address;
        repeat (3) @(rd_drv_if.read_driver_cb);
        rd_drv_if.read_driver_cb.read_enable <= 0;
    endtask

    task start();
        fork
            forever begin
                gen_read_mntr.get(data_dut);
                drive();
            end
        join_none;
    endtask
endclass
