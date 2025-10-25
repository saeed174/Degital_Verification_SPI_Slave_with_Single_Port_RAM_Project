interface Wrapper_inf(input clk);
    logic MOSI, SS_n, rst_n;
    logic MISO;

    modport dut (input clk, MOSI, rst_n, SS_n, output MISO);
endinterface