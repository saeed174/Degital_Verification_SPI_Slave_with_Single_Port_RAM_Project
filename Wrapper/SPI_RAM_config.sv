package SPI_RAM_config_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    class SPI_RAM_config extends uvm_object;
        `uvm_object_utils(SPI_RAM_config)

        virtual SPI_slave_inf SPI_vif;
        virtual SPI_slave_gm_inf SPI_vif_gm;
        virtual RAM_if vif;
        virtual RAM_if_ref vif_ref;
        virtual Wrapper_inf wrapper_inf;
        virtual Wrapper_gm_inf wrapper_inf_gm;
        uvm_active_passive_enum is_active;
        function new(string name = "SPI_RAM_config");
            super.new(name);
        endfunction
    endclass
endpackage