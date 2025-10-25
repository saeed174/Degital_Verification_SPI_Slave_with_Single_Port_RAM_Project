package RAM_coverage;
import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_seq_item::*;
class RAM_coverage extends uvm_component;
`uvm_component_utils(RAM_coverage)
uvm_analysis_export #(RAM_seq_item) cov_export;
uvm_tlm_analysis_fifo #(RAM_seq_item) cov_fifo;
RAM_seq_item seq_item;

// =====covergroups=====

covergroup COV;
c1:coverpoint seq_item.din[9:8]{
      bins write_addr = {2'b00};
      bins write_data = {2'b01};
      bins read_addr  = {2'b10};
      bins read_data  = {2'b11};
      bins write_addr_data =(0=>1);
      bins read_addr_data  =(2=>3);
      bins write_read =(0=>1=>2=>3);

}
rx_valid_cp:coverpoint seq_item.rx_valid{
      bins rx_valid_0 = {0};
      bins rx_valid_1 = {1};
}
tx_valid_cp:coverpoint seq_item.tx_valid{
      bins tx_valid_0 = {0};
      bins tx_valid_1 = {1};
}
cross rx_valid_cp,c1{
      option.cross_auto_bin_max=0;
      bins b1 = binsof(rx_valid_cp.rx_valid_0) && binsof(c1.write_addr);
      bins b2 = binsof(rx_valid_cp.rx_valid_1) && binsof(c1.write_data);
      bins b3 = binsof(rx_valid_cp.rx_valid_1) && binsof(c1.read_addr);
      bins b4 = binsof(rx_valid_cp.rx_valid_1) && binsof(c1.read_data);
}
cross tx_valid_cp,c1{
      option.cross_auto_bin_max=0;
      bins read_data_valid = binsof(tx_valid_cp.tx_valid_1) && binsof(c1.read_data);

}

endgroup



function new(string name="RAM_coverage", uvm_component parent=null);
    super.new(name, parent);
    COV= new();
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cov_export = new("cov_export", this);
    cov_fifo = new("cov_fifo", this);
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    cov_export.connect(cov_fifo.analysis_export);
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        cov_fifo.get(seq_item);
        COV.sample();
    end
endtask




endclass

endpackage