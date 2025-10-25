package RAM_monitor_ref;
import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_seq_item::*;
import RAM_config::*;
class RAM_monitor_ref extends uvm_monitor;
`uvm_component_utils(RAM_monitor_ref)
virtual RAM_if_ref vif_ref;
RAM_seq_item seq_item;
uvm_analysis_port #(RAM_seq_item) mon_ref_ap;
RAM_config cfg;
function new(string name="RAM_monitor_ref", uvm_component parent=null);
      super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_ref_ap = new("mon_ref_ap", this);
      if(!uvm_config_db#(RAM_config)::get(this, "", "cfg", cfg)) begin
            `uvm_fatal("NOVIF","Virtual interface reference must be set for: via configuration database");
      end
endfunction
function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
      vif_ref = cfg.vif_ref;
endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin
      seq_item = RAM_seq_item::type_id::create("seq_item");
      @(negedge vif_ref.clk);
      seq_item.rst_n = vif_ref.rst_n;
      seq_item.rx_valid = vif_ref.rx_valid;
      seq_item.din = vif_ref.din;
      seq_item.dout = vif_ref.dout;
      seq_item.tx_valid = vif_ref.tx_valid;
      mon_ref_ap.write(seq_item);
end
endtask

endclass
endpackage