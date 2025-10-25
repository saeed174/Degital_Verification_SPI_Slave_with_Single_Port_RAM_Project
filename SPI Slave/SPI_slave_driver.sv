package SPI_slave_driver_pkg;
    import uvm_pkg::*;
    import SPI_RAM_config_pkg::*;
    import SPI_slave_sequenceitem_pkg::*;
    `include "uvm_macros.svh"
    class SPI_slave_driver extends uvm_driver #(SPI_slave_sequenceitem);
        `uvm_component_utils(SPI_slave_driver)
        virtual SPI_slave_inf SPI_slave_driver_inf;
        virtual SPI_slave_gm_inf SPI_slave_driver_inf_gm;
        SPI_slave_sequenceitem item;
        function new(string name = "SPI_slave_driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            `uvm_info("SPI_slave_driver", "inside the SPI_slave driver", UVM_LOW);
            item = SPI_slave_sequenceitem::type_id::create("item");
            forever begin
                seq_item_port.get_next_item(item);
                SPI_slave_driver_inf.MOSI = item.MOSI;
                SPI_slave_driver_inf.rst_n = item.rst_n;
                SPI_slave_driver_inf.SS_n = item.SS_n;
                SPI_slave_driver_inf.tx_valid = item.tx_valid;
                SPI_slave_driver_inf.tx_data = item.tx_data;
                SPI_slave_driver_inf_gm.tx_data = item.tx_data;
                SPI_slave_driver_inf_gm.MOSI = item.MOSI;
                SPI_slave_driver_inf_gm.rst_n = item.rst_n;
                SPI_slave_driver_inf_gm.SS_n = item.SS_n;
                SPI_slave_driver_inf_gm.tx_valid = item.tx_valid;
                seq_item_port.item_done();
                @(negedge SPI_slave_driver_inf.clk);
                item.MISO = SPI_slave_driver_inf.MISO;
                item.rx_valid = SPI_slave_driver_inf.rx_valid;
                item.rx_data = SPI_slave_driver_inf.rx_data;
                `uvm_info("SPI_slave_driver", item.convert2string(), UVM_LOW);
            end
        endtask

    endclass
endpackage