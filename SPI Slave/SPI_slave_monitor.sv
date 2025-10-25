package SPI_slave_monitor_pkg;
    import uvm_pkg::*;
    import SPI_RAM_config_pkg::*;
    import SPI_slave_sequenceitem_pkg::*;
    `include "uvm_macros.svh"
    class SPI_slave_monitor extends uvm_monitor;
        `uvm_component_utils(SPI_slave_monitor)
        virtual SPI_slave_inf SPI_slave_monitor_inf;
        virtual SPI_slave_gm_inf SPI_slave_monitor_inf_gm;
        SPI_slave_sequenceitem item;
        SPI_slave_sequenceitem item_gm;
        uvm_analysis_port#(SPI_slave_sequenceitem) mon_ap;
        uvm_analysis_port#(SPI_slave_sequenceitem) mon_ap_gm;

        function new(string name = "SPI_slave_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap", this);
            mon_ap_gm = new("mon_ap_gm", this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            `uvm_info("SPI_slave_monitor", "inside the SPI_slave monitor", UVM_LOW);
            forever begin
                @(negedge SPI_slave_monitor_inf.clk);
                
                item_gm = SPI_slave_sequenceitem::type_id::create("item_gm");
                item_gm.MOSI = SPI_slave_monitor_inf_gm.MOSI;
                item_gm.rst_n = SPI_slave_monitor_inf_gm.rst_n;
                item_gm.SS_n = SPI_slave_monitor_inf_gm.SS_n;
                item_gm.tx_valid = SPI_slave_monitor_inf_gm.tx_valid;
                item_gm.tx_data = SPI_slave_monitor_inf_gm.tx_data;
                item_gm.MISO = SPI_slave_monitor_inf_gm.MISO;
                item_gm.rx_valid = SPI_slave_monitor_inf_gm.rx_valid;
                item_gm.rx_data = SPI_slave_monitor_inf_gm.rx_data;


                item = SPI_slave_sequenceitem::type_id::create("item");
                item.MOSI = SPI_slave_monitor_inf.MOSI;
                item.rst_n = SPI_slave_monitor_inf.rst_n;
                item.SS_n = SPI_slave_monitor_inf.SS_n;
                item.tx_valid = SPI_slave_monitor_inf.tx_valid;
                item.tx_data = SPI_slave_monitor_inf.tx_data;
                item.MISO = SPI_slave_monitor_inf.MISO;
                item.rx_valid = SPI_slave_monitor_inf.rx_valid;
                item.rx_data = SPI_slave_monitor_inf.rx_data;
                
                mon_ap_gm.write(item_gm);
                mon_ap.write(item);
                `uvm_info("SPI_slave_monitor", item.convert2string(), UVM_LOW);
            end
        endtask

    endclass
endpackage