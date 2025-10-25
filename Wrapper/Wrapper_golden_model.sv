module Wrapper_golden_model (Wrapper_gm_inf.dut wrapper_inf_gm , SPI_slave_gm_inf.dut if_gm , RAM_if_ref.dut RAM_if_ref_inst);

    RAM_ref   RAM_instance   (RAM_if_ref_inst);
    SPI_Slave_golden_model SLAVE_instance (if_gm);

    always @(*) begin
        if_gm.MOSI = wrapper_inf_gm.MOSI;
        if_gm.SS_n = wrapper_inf_gm.SS_n;
        if_gm.rst_n = wrapper_inf_gm.rst_n;
        wrapper_inf_gm.MISO = if_gm.MISO;
        if_gm.rst_n = wrapper_inf_gm.rst_n;

        if(if_gm.rx_valid) begin
            RAM_if_ref_inst.din = if_gm.rx_data;
        end
        RAM_if_ref_inst.rx_valid = if_gm.rx_valid;
        if_gm.tx_data = RAM_if_ref_inst.dout;
        if_gm.tx_valid = RAM_if_ref_inst.tx_valid;
        RAM_if_ref_inst.rst_n = wrapper_inf_gm.rst_n;
    end

endmodule