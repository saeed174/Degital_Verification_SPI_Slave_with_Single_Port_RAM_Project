package Wrapper_driver_pkg;
    import uvm_pkg::*;
    import SPI_RAM_config_pkg::*;
    import Wrapper_sequenceitem_pkg::*;
    `include "uvm_macros.svh"
    class Wrapper_driver extends uvm_driver #(Wrapper_sequenceitem);
        `uvm_component_utils(Wrapper_driver)
        virtual Wrapper_inf Wrapper_driver_inf;
        virtual Wrapper_gm_inf Wrapper_driver_inf_gm;
        Wrapper_sequenceitem item;
        function new(string name = "Wrapper_driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            `uvm_info("Wrapper_driver", "inside the Wrapper driver", UVM_LOW);
            item = Wrapper_sequenceitem::type_id::create("item");
            forever begin
                seq_item_port.get_next_item(item);
                Wrapper_driver_inf.MOSI = item.MOSI;
                Wrapper_driver_inf.rst_n = item.rst_n;
                Wrapper_driver_inf.SS_n = item.SS_n;

                Wrapper_driver_inf_gm.MOSI = item.MOSI;
                Wrapper_driver_inf_gm.rst_n = item.rst_n;
                Wrapper_driver_inf_gm.SS_n = item.SS_n;
                
                seq_item_port.item_done();
                @(negedge Wrapper_driver_inf.clk);
                item.MISO = Wrapper_driver_inf.MISO;
                `uvm_info("Wrapper_driver", item.convert2string(), UVM_LOW);
            end
        endtask

    endclass
endpackage