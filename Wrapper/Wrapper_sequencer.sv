package Wrapper_sequencer_pkg;
    import uvm_pkg::*;
    import Wrapper_sequenceitem_pkg::*;
    `include "uvm_macros.svh"
    class Wrapper_sequencer extends uvm_sequencer #(Wrapper_sequenceitem);
        `uvm_component_utils(Wrapper_sequencer)
        function new(string name = "Wrapper_sequencer", uvm_component parent = null);
            super.new(name, parent);
        endfunction
    endclass
endpackage