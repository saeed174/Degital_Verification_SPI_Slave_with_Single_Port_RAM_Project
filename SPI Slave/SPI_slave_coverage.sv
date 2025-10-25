package SPI_slave_coverage_pkg;
    import uvm_pkg::*;
    import SPI_slave_sequenceitem_pkg::*;
    `include "uvm_macros.svh"
    class SPI_slave_coverage extends uvm_component;
        `uvm_component_utils(SPI_slave_coverage)
        SPI_slave_sequenceitem item;
        uvm_analysis_export #(SPI_slave_sequenceitem) cv_export;
        uvm_tlm_analysis_fifo #(SPI_slave_sequenceitem) cv_fifo;
        bit pervious_SS_n;

        covergroup cg;
            rx_data_cp: coverpoint item.rx_data[9:8];
            SS_n_cp: coverpoint item.SS_n{
                bins transition13 = (1'b1 => 0[*13] => 1'b1);
                bins transition23 = (1'b1 => 0[*23] => 1'b1);
            }
            MOSI_add_cp: coverpoint item.MOSI {
                option.auto_bin_max = 0;
                bins write_address = (0 => 0 => 0);
                bins write_data = (0 => 0 => 1);
                bins read_address = (1 => 1 => 0);
                bins read_data = (1 => 1 => 1);
            }

            SS_n_MOSI_cc: cross SS_n_cp,MOSI_add_cp {
                ignore_bins illegal2 = binsof(SS_n_cp.transition23) && binsof(MOSI_add_cp.write_data);
                ignore_bins illegal4 = binsof(SS_n_cp.transition13) && binsof(MOSI_add_cp.read_data);
                ignore_bins illegal5 = binsof(SS_n_cp.transition13) && (binsof(MOSI_add_cp.write_data));
                ignore_bins illegal6 = binsof(SS_n_cp.transition23) && binsof(MOSI_add_cp.read_data);
                ignore_bins illegal7 = binsof(SS_n_cp.transition23) && (binsof(MOSI_add_cp.read_address));
                ignore_bins illegal8 = binsof(SS_n_cp.transition13) && binsof(MOSI_add_cp.read_address);

            }
        endgroup

        function new(string name = "SPI_slave_coverage", uvm_component parent = null);
            super.new(name, parent);
            cg = new();
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cv_export = new("cv_export", this);
            cv_fifo = new("cv_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cv_export.connect(cv_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cv_fifo.get(item);
                pervious_SS_n = item.SS_n;
                cg.sample();
            end
        endtask

    endclass
endpackage