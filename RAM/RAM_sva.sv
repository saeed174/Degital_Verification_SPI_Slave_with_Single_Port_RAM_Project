module RAM_sva (RAM_if.DUT DUT_if);

//==reset assertion
property rst_check;
@(posedge DUT_if.clk) !DUT_if.rst_n |=> ((DUT_if.dout)==8'b00000000 &&DUT_if.tx_valid==0);
endproperty
assert property (rst_check) else $error("Reset assertion failed");
cover property (rst_check);

// ===tx_valid_low assertion====
property tx_valid_low_check;
@(posedge DUT_if.clk) disable iff (!DUT_if.rst_n) (DUT_if.din[9:8]!=2'b11) |=> (DUT_if.tx_valid)==0;
endproperty
assert property (tx_valid_low_check) else $error("tx_valid_low assertion failed");
cover property (tx_valid_low_check);
// ===tx_valid_high assertion====
property tx_valid_high_check;
@(posedge DUT_if.clk) disable iff (!DUT_if.rst_n) ($past(DUT_if.din[9:8])==2'b10&& DUT_if.din[9:8]==2'b11) |=> ($rose(DUT_if.tx_valid))|=>##[1:$]($fell(DUT_if.tx_valid));
endproperty
assert property (tx_valid_high_check) else $error("tx_valid_high assertion failed");
cover property (tx_valid_high_check);

// ====write address then write data assertion====
property write_addr_data_check;
@(posedge DUT_if.clk) disable iff (!DUT_if.rst_n) (DUT_if.din[9:8]==2'b00) |=> ##[1:$] (DUT_if.din[9:8]==2'b01);
endproperty 
assert property (write_addr_data_check) else $error("write_addr_data assertion failed");
cover property (write_addr_data_check);

// ====read address then read data assertion====
property read_addr_data_check;
@(posedge DUT_if.clk) disable iff (!DUT_if.rst_n) (DUT_if.din[9:8]==2'b10) |=> ##[1:$] (DUT_if.din[9:8]==2'b11);
endproperty 
assert property (read_addr_data_check) else $error("read_addr_data assertion failed");
cover property (read_addr_data_check);






endmodule