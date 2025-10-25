interface SPI_slave_inf(input clk);
    logic MOSI, rst_n, SS_n, tx_valid;
    logic [7:0] tx_data;
    logic [9:0] rx_data;
    logic rx_valid, MISO;

    modport dut (
        input clk, MOSI, rst_n, SS_n, tx_valid,tx_data,
        output rx_data,rx_valid, MISO
    );

    modport mon (
        input clk, MOSI, rst_n, SS_n, tx_valid,tx_data,
        input rx_data,rx_valid, MISO
    );
endinterface