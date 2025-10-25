package SPI_slave_agent_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SPI_RAM_config_pkg::*;
    import SPI_slave_sequencer_pkg::*;
    import SPI_slave_driver_pkg::*;
    import SPI_slave_monitor_pkg::*;
    import SPI_slave_sequenceitem_pkg::*;
    class SPI_slave_agent extends uvm_agent;
        `uvm_component_utils(SPI_slave_agent)
        SPI_slave_driver driver;
        SPI_slave_monitor monitor;
        SPI_slave_sequencer sequencer;
        SPI_RAM_config cfg;
        uvm_analysis_port #(SPI_slave_sequenceitem) agt_ap;
        uvm_analysis_port #(SPI_slave_sequenceitem) agt_ap_gm;

        function new(string name = "SPI_slave_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db#(SPI_RAM_config)::get(this, "", "SPI_slave_config_test", cfg)) begin
                `uvm_fatal("SPI_slave_agent", "virtual interface must be set for SPI_slave_agent")
            end
            sequencer = SPI_slave_sequencer::type_id::create("sequencer", this);
            driver = SPI_slave_driver::type_id::create("driver", this);
            monitor = SPI_slave_monitor::type_id::create("monitor", this);
            agt_ap = new("agt_ap", this);
            agt_ap_gm = new("agt_ap_gm", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            driver.SPI_slave_driver_inf = cfg.SPI_vif;
            driver.SPI_slave_driver_inf_gm = cfg.SPI_vif_gm;
            monitor.SPI_slave_monitor_inf = cfg.SPI_vif;
            monitor.SPI_slave_monitor_inf_gm = cfg.SPI_vif_gm;
            driver.seq_item_port.connect(sequencer.seq_item_export);
            monitor.mon_ap.connect(agt_ap);
            monitor.mon_ap_gm.connect(agt_ap_gm);
        endfunction

    endclass

endpackage