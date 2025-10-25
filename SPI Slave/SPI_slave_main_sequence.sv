package SPI_slave_random_sequence_pkg;
    import uvm_pkg::*;
    import SPI_slave_sequenceitem_pkg::*;
    `include "uvm_macros.svh"
    class SPI_slave_random_sequence extends uvm_sequence #(SPI_slave_sequenceitem);
        `uvm_object_utils(SPI_slave_random_sequence)
        SPI_slave_sequenceitem item;
        function new(string name = "SPI_slave_random_sequence");
            super.new(name);
        endfunction

        task body();
            item = SPI_slave_sequenceitem::type_id::create("item");
            for (int i = 0; i < 100000 ; i++) begin
                start_item(item);
                assert(item.randomize());
                finish_item(item);
            end
        endtask
    endclass
endpackage