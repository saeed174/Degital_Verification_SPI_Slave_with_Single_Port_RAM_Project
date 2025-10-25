package RAM_seq_item;  
import uvm_pkg::*;
`include "uvm_macros.svh"
class RAM_seq_item extends uvm_sequence_item;
`uvm_object_utils(RAM_seq_item)
rand logic  [9:0] din;
rand logic rx_valid;
rand logic rst_n;
rand logic [7:0] dout;
rand logic tx_valid;
logic [1:0]old_op=2'b00;

function new(string name="RAM_seq_item");
    super.new(name);
endfunction

function string convert2string();
    return $sformatf("din=%0h, rx_valid=%0b, dout=%0h, tx_valid=%0b", din, rx_valid, dout, tx_valid);
endfunction

// ====constraints====
constraint reset_cn {
      rst_n dist {0:=1, 1:=9}; 
}

constraint rx_valid_cn {
      rx_valid dist {0:=1, 1:=9}; 
}

constraint write_cn {
      din[9:8] inside {[0:1]};
      
}
constraint read_cn {
       din[9:8] inside {[2:3]};

      
}
constraint read_write_cn {
      if (old_op==2'b00) {
            din[9:8] inside {[0:1]};
      }
      else if (old_op==2'b01) {
           din[9:8] dist {0:=40, 2:=60};
      }
      else if (old_op==2'b10) {
            din[9:8] inside {[2:3]};

      }
      else if (old_op==2'b11) {
               din[9:8] dist {0:=60, 2:=40};
            
      }
     
      
}
function void post_randomize();
old_op=din[9:8];

endfunction


endclass

endpackage