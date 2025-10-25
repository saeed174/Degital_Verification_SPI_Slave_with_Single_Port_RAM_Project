package Wrapper_monitor_pkg;
    import uvm_pkg::*;
    import SPI_RAM_config_pkg::*;
    import Wrapper_sequenceitem_pkg::*;
    `include "uvm_macros.svh"
    class Wrapper_monitor extends uvm_monitor;
        `uvm_component_utils(Wrapper_monitor)
        virtual Wrapper_inf Wrapper_monitor_inf;
        virtual Wrapper_gm_inf Wrapper_monitor_inf_gm;
        Wrapper_sequenceitem item;
        Wrapper_sequenceitem item_gm;
        uvm_analysis_port#(Wrapper_sequenceitem) mon_ap;
        uvm_analysis_port#(Wrapper_sequenceitem) mon_ap_gm;

        function new(string name = "Wrapper_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap", this);
            mon_ap_gm = new("mon_ap_gm", this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            `uvm_info("Wrapper_monitor", "inside the Wrapper monitor", UVM_LOW);
            forever begin
                @(negedge Wrapper_monitor_inf.clk);
                
                item_gm = Wrapper_sequenceitem::type_id::create("item_gm");
                item_gm.MOSI = Wrapper_monitor_inf_gm.MOSI;
                item_gm.rst_n = Wrapper_monitor_inf_gm.rst_n;
                item_gm.SS_n = Wrapper_monitor_inf_gm.SS_n;
                item_gm.MISO = Wrapper_monitor_inf_gm.MISO;


                item = Wrapper_sequenceitem::type_id::create("item");
                item.MOSI = Wrapper_monitor_inf.MOSI;
                item.rst_n = Wrapper_monitor_inf.rst_n;
                item.SS_n = Wrapper_monitor_inf.SS_n;
                item.MISO = Wrapper_monitor_inf.MISO;
                
                mon_ap_gm.write(item_gm);
                mon_ap.write(item);
                `uvm_info("Wrapper_monitor", item.convert2string(), UVM_LOW);
            end
        endtask

    endclass
endpackage