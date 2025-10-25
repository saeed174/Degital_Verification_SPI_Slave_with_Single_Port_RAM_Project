package SPI_slave_rst_sequence_pkg;
    import uvm_pkg::*;
    import SPI_slave_sequenceitem_pkg::*;
    `include "uvm_macros.svh"
    class SPI_slave_rst_sequence extends uvm_sequence #(SPI_slave_sequenceitem);
        `uvm_object_utils(SPI_slave_rst_sequence)
        SPI_slave_sequenceitem item;
        function new(string name = "SPI_slave_rst_sequence");
            super.new(name);
        endfunction

        task body();
            item = SPI_slave_sequenceitem::type_id::create("item");
            start_item(item);
            item.rst_n = 0;
            item.tx_valid = 0;
            item.tx_data = 0;
            item.MISO = 0;
            finish_item(item);
        endtask
    endclass
endpackage