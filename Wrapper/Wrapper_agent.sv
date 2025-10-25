package Wrapper_agent_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import SPI_RAM_config_pkg::*;
    import Wrapper_sequencer_pkg::*;
    import Wrapper_driver_pkg::*;
    import Wrapper_monitor_pkg::*;
    import Wrapper_sequenceitem_pkg::*;
    class Wrapper_agent extends uvm_agent;
        `uvm_component_utils(Wrapper_agent)
        Wrapper_driver driver;
        Wrapper_monitor monitor;
        Wrapper_sequencer sequencer;
        SPI_RAM_config cfg;
        uvm_analysis_port #(Wrapper_sequenceitem) agt_ap;
        uvm_analysis_port #(Wrapper_sequenceitem) agt_ap_gm;

        function new(string name = "Wrapper_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db#(SPI_RAM_config)::get(this, "", "wrapper_cfg", cfg)) begin
                `uvm_fatal("Wrapper_agent", "virtual interface must be set for Wrapper_agent")
            end
            if(cfg.is_active == UVM_ACTIVE) begin
                sequencer = Wrapper_sequencer::type_id::create("sequencer", this);
                driver = Wrapper_driver::type_id::create("driver", this);
            end
            monitor = Wrapper_monitor::type_id::create("monitor", this);
            agt_ap = new("agt_ap", this);
            agt_ap_gm = new("agt_ap_gm", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            driver.Wrapper_driver_inf = cfg.wrapper_inf;
            driver.Wrapper_driver_inf_gm = cfg.wrapper_inf_gm;
            monitor.Wrapper_monitor_inf = cfg.wrapper_inf;
            monitor.Wrapper_monitor_inf_gm = cfg.wrapper_inf_gm;
            driver.seq_item_port.connect(sequencer.seq_item_export);
            monitor.mon_ap.connect(agt_ap);
            monitor.mon_ap_gm.connect(agt_ap_gm);
        endfunction

    endclass

endpackage