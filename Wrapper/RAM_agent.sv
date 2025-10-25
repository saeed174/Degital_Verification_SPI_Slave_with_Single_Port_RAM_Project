package RAM_agent;
import uvm_pkg::*;
import RAM_driver::*;
import RAM_sequencer::*;
import RAM_monitor::*;
import SPI_RAM_config_pkg::*;
import RAM_seq_item::*;
`include "uvm_macros.svh"
class RAM_agent extends uvm_agent;
`uvm_component_utils(RAM_agent)
RAM_driver driver;
RAM_sequencer sequencer;
RAM_monitor monitor;
SPI_RAM_config cfg;
uvm_analysis_port #(RAM_seq_item) agent_ap;

function new(string name="RAM_agent", uvm_component parent=null);
    super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(SPI_RAM_config)::get(this, "", "cfg", cfg)) begin
        `uvm_fatal("NOVIF","Virtual interface must be set for: via configuration database");
    end
    if(cfg.is_active == UVM_ACTIVE) begin
        sequencer = RAM_sequencer::type_id::create("sequencer", this);
        driver = RAM_driver::type_id::create("driver", this);
    end
    monitor = RAM_monitor::type_id::create("monitor", this);
      agent_ap = new("agent_ap", this);
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    monitor.vif = cfg.vif;
    monitor.mon_ap.connect(agent_ap);
    if(cfg.is_active == UVM_ACTIVE) begin
        driver.vif = cfg.vif;
        driver.seq_item_port.connect(sequencer.seq_item_export);
    end
endfunction
endclass

      
endpackage