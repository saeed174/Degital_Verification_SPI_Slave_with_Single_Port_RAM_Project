package SPI_slave_scoreboard_pkg;
    import uvm_pkg::*;
    import SPI_slave_sequenceitem_pkg::*;
    `include "uvm_macros.svh"
    class SPI_slave_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(SPI_slave_scoreboard)
        uvm_analysis_export #(SPI_slave_sequenceitem) sb_export;
        uvm_tlm_analysis_fifo #(SPI_slave_sequenceitem) sb_fifo;
        uvm_analysis_export #(SPI_slave_sequenceitem) sb_export_gm;
        uvm_tlm_analysis_fifo #(SPI_slave_sequenceitem) sb_fifo_gm;
        SPI_slave_sequenceitem item;
        SPI_slave_sequenceitem item_gm;

        
        int correct_count = 0 , error_count = 0;
        function new(string name = "SPI_slave_scoreboard", uvm_component parent = null);
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
                
                if(item.MISO === item_gm.MISO && item.rx_valid === item_gm.rx_valid && item.rx_data === item_gm.rx_data) begin
                    correct_count = correct_count + 1;
                end
                else begin
                    `uvm_error("run_phase", $sformatf("MISO = %d, rx_data = %d, rx_valid = %d", item.MISO, item.rx_data, item.rx_valid));
                    `uvm_error("run_phase", $sformatf("MISO = %d, rx_data = %d, rx_valid = %d", item_gm.MISO, item_gm.rx_data, item_gm.rx_valid));
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