package Wrapper_rst_sequence_pkg;
    import uvm_pkg::*;
    import Wrapper_sequenceitem_pkg::*;
    `include "uvm_macros.svh"
    class Wrapper_rst_sequence extends uvm_sequence #(Wrapper_sequenceitem);
        `uvm_object_utils(Wrapper_rst_sequence)
        Wrapper_sequenceitem item;
        function new(string name = "Wrapper_rst_sequence");
            super.new(name);
        endfunction

        task body();
            item = Wrapper_sequenceitem::type_id::create("item");
            start_item(item);
            item.rst_n = 0;
            item.MISO = 0;
            item.SS_n = 1;
            finish_item(item);
        endtask
    endclass
endpackage