package Wrapper_test_pkg;
    import uvm_pkg::*;
    import SPI_slave_env_pkg::*;
    import SPI_RAM_config_pkg::*;
    import Wrapper_write_only_sequence_pkg::*;
    import Wrapper_read_only_sequence_pkg::*;
    import Wrapper_rst_sequence_pkg::*;
    import Wrapper_read_write_sequence_pkg::*;
    import RAM_env::*;
    import Wrapper_env_pkg::*;
    `include "uvm_macros.svh"
    class Wrapper_test extends uvm_test;
        `uvm_component_utils(Wrapper_test)

        SPI_slave_env spi_env;
        RAM_env env;
        Wrapper_env wrapper_env;
        SPI_RAM_config spi_cfg;
        SPI_RAM_config ram_cfg;
        SPI_RAM_config wrapper_cfg;
        Wrapper_write_only_sequence write_only_seq;
        Wrapper_read_only_sequence read_only_seq;
        Wrapper_rst_sequence rst_seq;
        Wrapper_read_write_sequence read_write_seq;

        function new(string name = "Wrapper_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            spi_env = SPI_slave_env::type_id::create("spi_env", this);
            env = RAM_env::type_id::create("env", this);
            wrapper_env = Wrapper_env::type_id::create("wrapper_env", this);
            spi_cfg = SPI_RAM_config::type_id::create("spi_cfg");
            ram_cfg = SPI_RAM_config::type_id::create("ram_cfg");
            wrapper_cfg = SPI_RAM_config::type_id::create("wrapper_cfg");
            // create the rst and main sequence
            rst_seq = Wrapper_rst_sequence::type_id::create("rst_seq");
            write_only_seq = Wrapper_write_only_sequence::type_id::create("write_only_seq");
            read_only_seq = Wrapper_read_only_sequence::type_id::create("read_only_seq");
            read_write_seq = Wrapper_read_write_sequence::type_id::create("read_write_seq");
            if (!uvm_config_db#(virtual SPI_slave_inf)::get(this, "", "vif", spi_cfg.SPI_vif)) begin
                `uvm_fatal("Wrapper_test", "virtual interface must be set for Wrapper_test")
            end
            if (!uvm_config_db#(virtual SPI_slave_gm_inf)::get(this, "", "vif_gm", spi_cfg.SPI_vif_gm)) begin
                `uvm_fatal("Wrapper_test", "virtual interface must be set for Wrapper_test")
            end

            if (!uvm_config_db#(virtual Wrapper_inf)::get(this, "", "wrap_vif", wrapper_cfg.wrapper_inf)) begin
                `uvm_fatal("Wrapper_test", "virtual interface must be set for Wrapper_test")
            end
            if (!uvm_config_db#(virtual Wrapper_gm_inf)::get(this, "", "wrap_ref", wrapper_cfg.wrapper_inf_gm)) begin
                `uvm_fatal("Wrapper_test", "virtual interface must be set for Wrapper_test")
            end

            if(!uvm_config_db#(virtual RAM_if)::get(this, "", "vif_DUT", ram_cfg.vif)) begin
                `uvm_fatal("NOVIF","Virtual interface must be set for:  via configuration database");
            end
            if(!uvm_config_db#(virtual RAM_if_ref)::get(this, "", "vif_REF", ram_cfg.vif_ref)) begin
                `uvm_fatal("NOVIF","Virtual interface reference must be set for: via configuration database");
            end

            spi_cfg.is_active = UVM_PASSIVE;
            ram_cfg.is_active = UVM_PASSIVE;
            wrapper_cfg.is_active = UVM_ACTIVE;

            uvm_config_db#(SPI_RAM_config)::set(this, "*", "SPI_slave_config_test", spi_cfg);
            uvm_config_db#(SPI_RAM_config)::set(this, "*", "cfg", ram_cfg);
            uvm_config_db#(SPI_RAM_config)::set(this, "*", "wrapper_cfg", wrapper_cfg);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            `uvm_info("Wrapper_test", "rst_sequence start", UVM_LOW);
            rst_seq.start(wrapper_env.agent.sequencer);
            `uvm_info("Wrapper_test", "rst_sequence end", UVM_LOW);
            `uvm_info("Wrapper_test", "write_only_sequence start", UVM_LOW);
            write_only_seq.start(wrapper_env.agent.sequencer);
            `uvm_info("Wrapper_test", "write_only_sequence end", UVM_LOW);
            `uvm_info("Wrapper_test", "read_only_sequence start", UVM_LOW);
            read_only_seq.start(wrapper_env.agent.sequencer);
            `uvm_info("Wrapper_test", "read_only_sequence end", UVM_LOW);
            `uvm_info("Wrapper_test", "read_write_sequence start", UVM_LOW);
            read_write_seq.start(wrapper_env.agent.sequencer);
            `uvm_info("Wrapper_test", "read_write_sequence end", UVM_LOW);
            phase.drop_objection(this);
        endtask
    endclass
endpackage