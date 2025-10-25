package RAM_scoreboard;
import uvm_pkg::*;
import RAM_seq_item::*;
import RAM_config::*;
`include "uvm_macros.svh"
class RAM_scoreboard extends uvm_scoreboard;
`uvm_component_utils(RAM_scoreboard)
int correct_count=0;
int error_count=0;
uvm_analysis_export #(RAM_seq_item) sb_export;
uvm_tlm_analysis_fifo #(RAM_seq_item) sb_fifo;
uvm_analysis_export #(RAM_seq_item) sb_export_ref;
uvm_tlm_analysis_fifo #(RAM_seq_item) sb_fifo_ref;
RAM_seq_item seq_item;
RAM_seq_item seq_item_ref;
function new(string name="RAM_scoreboard", uvm_component parent=null);
      super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_export = new("sb_export", this);
    sb_fifo = new("sb_fifo", this);
      sb_export_ref = new("sb_export_ref", this);
      sb_fifo_ref = new("sb_fifo_ref", this);
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sb_export.connect(sb_fifo.analysis_export);
      sb_export_ref.connect(sb_fifo_ref.analysis_export);
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        sb_fifo.get(seq_item);
       sb_fifo_ref.get(seq_item_ref);

      if(seq_item.dout!==seq_item_ref.dout&&seq_item.tx_valid!== seq_item_ref.tx_valid) begin
            `uvm_error("SCOREBOARD", $sformatf("Mismatch Detected! Expected Dout: %0h, Actual Dout: %0h, Expected Tx_Valid: %0b, Actual Tx_Valid: %0b", seq_item.dout, seq_item_ref.dout, seq_item.tx_valid, seq_item_ref.tx_valid));
            error_count++;
      end
      else begin
            correct_count++;
      end
    end
endtask
function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("SCOREBOARD", $sformatf("Correct Transactions: %0d, Error Transactions: %0d", correct_count, error_count), UVM_LOW);
endfunction

endclass
endpackage