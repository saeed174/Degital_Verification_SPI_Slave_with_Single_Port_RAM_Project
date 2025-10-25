module Wrapper (Wrapper_inf.dut if_wrapper , SPI_slave_inf.dut if_c , RAM_if.dut if_ram);

    RAM   RAM_instance   (if_ram);
    SPI_slave SLAVE_instance (if_c);

    always @(*) begin
        if_c.MOSI = if_wrapper.MOSI;
        if_c.SS_n = if_wrapper.SS_n;
        if_c.rst_n = if_wrapper.rst_n;
        if_wrapper.MISO = if_c.MISO;
        if_c.rst_n = if_wrapper.rst_n;

        if(if_c.rx_valid) begin
            if_ram.din = if_c.rx_data;
        end
        if_ram.rx_valid = if_c.rx_valid;
        if_c.tx_data = if_ram.dout;
        if_c.tx_valid = if_ram.tx_valid;
        if_ram.rst_n = if_wrapper.rst_n;
    end

endmodule