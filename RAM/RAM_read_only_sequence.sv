package RAM_read_only_sequence;
import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_seq_item::*;
class read_only_sequence extends uvm_sequence #(RAM_seq_item);
`uvm_object_utils(read_only_sequence)
RAM_seq_item seq_item;
function new(string name = "read_only_sequence");
    super.new(name);
endfunction

task body();
repeat(100) begin
seq_item = RAM_seq_item::type_id::create("seq_item");
start_item(seq_item);
seq_item.constraint_mode(0);
seq_item.reset_cn.constraint_mode(1);
seq_item.rx_valid_cn.constraint_mode(1);
seq_item.read_cn.constraint_mode(1);
 assert(seq_item.randomize());
finish_item(seq_item);
end


endtask
endclass
endpackage