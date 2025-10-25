package RAM_reset_sequence;
import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_seq_item::*;
class reset_sequence extends uvm_sequence #(RAM_seq_item);
`uvm_object_utils(reset_sequence)
RAM_seq_item seq_item;
function new(string name = "reset_sequence");
    super.new(name);
endfunction

task body();
seq_item = RAM_seq_item::type_id::create("seq_item");
start_item(seq_item);
seq_item.rst_n = 0;
seq_item.rx_valid = 0;
seq_item.din = 0;
seq_item.dout = 0;
seq_item.tx_valid = 0;
finish_item(seq_item);

endtask
endclass
endpackage