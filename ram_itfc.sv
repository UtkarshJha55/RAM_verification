// Interface file used for DUT and environment connection
interface ram_itfc(input bit clk);
    logic rstn;
    logic read_enable;
    logic write_enable;
    logic [4:0] write_address;
    logic [4:0] read_address;
    logic [31:0] data_in;
    logic [31:0] data_out;

    clocking write_driver_cb @(posedge clk);
        default input #1ns output #2ns;
        output write_address, data_in, write_enable;
    endclocking

    clocking read_driver_cb @(posedge clk);
        default input #1ns output #2ns;
        output read_address, read_enable;
    endclocking

    clocking write_monitor_cb @(posedge clk);
        default input #1ns output #2ns;
        input write_address, data_in, write_enable;
    endclocking

    clocking read_monitor_cb @(posedge clk);
        default input #1ns output #2ns;
        input read_address, data_out, read_enable;
    endclocking

    modport WR_DRV_MDPT (clocking write_driver_cb);
    modport RD_DRV_MDPT (clocking read_driver_cb);
    modport WR_MNTR_MDPT (clocking write_monitor_cb);
    modport RD_MNTR_MDPT (clocking read_monitor_cb);
endinterface
