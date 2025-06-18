// Used to create transactions for DUT. Consists of parts used for RAM
class transaction;
    rand logic read_enable;
    rand logic write_enable;
    rand logic [4:0] read_address;
    rand logic [4:0] write_address;
    rand logic [31:0] data_in;
    logic [31:0] data_out;
endclass
