package RAM_sequencer;
import uvm_pkg::*;
import RAM_seq_item::*;
`include "uvm_macros.svh"
class RAM_sequencer extends uvm_sequencer #(RAM_seq_item);
`uvm_component_utils(RAM_sequencer)
function new(string name="RAM_sequencer", uvm_component parent=null);
      super.new(name, parent);
endfunction
endclass
endpackage