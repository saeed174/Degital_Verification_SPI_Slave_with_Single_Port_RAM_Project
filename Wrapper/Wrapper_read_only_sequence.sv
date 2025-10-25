package Wrapper_read_only_sequence_pkg;
    import uvm_pkg::*;
    import Wrapper_sequenceitem_pkg::*;
    `include "uvm_macros.svh"
    class Wrapper_read_only_sequence extends uvm_sequence #(Wrapper_sequenceitem);
        `uvm_object_utils(Wrapper_read_only_sequence)
        Wrapper_sequenceitem item;
        function new(string name = "Wrapper_read_only_sequence");
            super.new(name);
        endfunction

        task body();
            item = Wrapper_sequenceitem::type_id::create("item");
            
            for (int i = 0; i < 500 ; i++) begin
                start_item(item);
                assert(item.randomize());
                if(item.SS_n == 1) begin
                    if(i % 2 == 0) begin
                        item.active_MOSI_word = {3'b110, item.active_MOSI_word[7:0]};
                    end
                    else begin
                        item.active_MOSI_word = {3'b111, item.active_MOSI_word[7:0]};
                    end
                end
                finish_item(item);
            end
        endtask
    endclass
endpackage