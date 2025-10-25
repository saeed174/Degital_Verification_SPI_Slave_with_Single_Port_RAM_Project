package Wrapper_read_write_sequence_pkg;
    import uvm_pkg::*;
    import Wrapper_sequenceitem_pkg::*;
    `include "uvm_macros.svh"
    class Wrapper_read_write_sequence extends uvm_sequence #(Wrapper_sequenceitem);
        `uvm_object_utils(Wrapper_read_write_sequence)
        Wrapper_sequenceitem item;
        function new(string name = "Wrapper_read_write_sequence");
            super.new(name);
        endfunction

        task body();
            item = Wrapper_sequenceitem::type_id::create("item");
            for (int i = 0; i < 10000 ; i++) begin
                start_item(item);
                assert(item.randomize());
                finish_item(item);
            end

            // for(int i = 0; i < item.N ; i++) begin
            //     $display("Command %0d: %b", i, item.cmd_seq[i]);
            // end
        endtask
    endclass
endpackage