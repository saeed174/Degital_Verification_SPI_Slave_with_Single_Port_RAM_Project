package RAM_driver;
import uvm_pkg::*;
import RAM_seq_item::*;
`include "uvm_macros.svh"
class RAM_driver extends uvm_driver #(RAM_seq_item);
`uvm_component_utils(RAM_driver)
virtual RAM_if vif;
RAM_seq_item seq_item;

function new(string name="RAM_driver", uvm_component parent=null);
      super.new(name, parent);
endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);
forever begin
      seq_item = RAM_seq_item::type_id::create("seq_item");
      seq_item_port.get_next_item(seq_item);
      vif.rst_n = seq_item.rst_n;
      vif.rx_valid = seq_item.rx_valid;
      vif.din = seq_item.din;
      @(negedge vif.clk);
      seq_item_port.item_done();
end

endtask
endclass

endpackage