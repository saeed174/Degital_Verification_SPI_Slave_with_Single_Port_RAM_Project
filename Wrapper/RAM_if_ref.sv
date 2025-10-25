interface RAM_if_ref(clk);
    input clk ;
    logic [9:0] din;
    logic  rst_n, rx_valid;
    logic [7:0] dout;
    logic tx_valid;
    modport dut (input din, clk, rst_n, rx_valid, output dout, tx_valid);
endinterface 