interface SPI_slave_gm_inf(input clk);
    logic MOSI,SS_n,rst_n;
    logic [7:0] tx_data;
    logic tx_valid,MISO;
    logic [9:0] rx_data;
    logic rx_valid;

    modport gm(
        input clk, MOSI, rst_n, SS_n, tx_valid,tx_data,
        output rx_data,rx_valid, MISO
    );
endinterface