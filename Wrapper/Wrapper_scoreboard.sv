package Wrapper_scoreboard_pkg;
    import uvm_pkg::*;
    import Wrapper_sequenceitem_pkg::*;
    `include "uvm_macros.svh"
    class Wrapper_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(Wrapper_scoreboard)
        uvm_analysis_export #(Wrapper_sequenceitem) sb_export;
        uvm_tlm_analysis_fifo #(Wrapper_sequenceitem) sb_fifo;
        uvm_analysis_export #(Wrapper_sequenceitem) sb_export_gm;
        uvm_tlm_analysis_fifo #(Wrapper_sequenceitem) sb_fifo_gm;
        Wrapper_sequenceitem item;
        Wrapper_sequenceitem item_gm;

        
        int correct_count = 0 , error_count = 0;
        function new(string name = "Wrapper_scoreboard", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_fifo = new("sb_fifo", this);
            sb_export = new("sb_export", this);
            sb_fifo_gm = new("sb_fifo_gm", this);
            sb_export_gm = new("sb_export_gm", this);
            sb_export.connect(sb_fifo.analysis_export);
            sb_export_gm.connect(sb_fifo_gm.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(item);
                sb_fifo_gm.get(item_gm);
                
                if(item.MISO === item_gm.MISO) begin
                    correct_count = correct_count + 1;
                end
                else begin
                    `uvm_error("run_phase", $sformatf("MISO = %d", item.MISO));
                    `uvm_error("run_phase", $sformatf("MISO = %d", item_gm.MISO));
                    error_count = error_count + 1;
                end
            end
        endtask


        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase", $sformatf("correct_count = %d", correct_count), UVM_LOW);
            `uvm_info("report_phase", $sformatf("error_count = %d", error_count), UVM_LOW);
        endfunction
    endclass
endpackage