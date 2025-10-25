package SPI_slave_test_pkg;
    import uvm_pkg::*;
    import SPI_slave_env_pkg::*;
    import SPI_RAM_config_pkg::*;
    import SPI_slave_rst_sequence_pkg::*;
    import SPI_slave_random_sequence_pkg::*;
    `include "uvm_macros.svh"
    class SPI_slave_test extends uvm_test;
        `uvm_component_utils(SPI_slave_test)

        SPI_slave_env env;
        SPI_RAM_config cfg;
        SPI_slave_rst_sequence rst_sequence;
        SPI_slave_random_sequence random_sequence;
        function new(string name = "SPI_slave_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = SPI_slave_env::type_id::create("env", this);
            cfg = SPI_RAM_config::type_id::create("cfg");
            rst_sequence = SPI_slave_rst_sequence::type_id::create("rst_sequence");
            random_sequence = SPI_slave_random_sequence::type_id::create("random_sequence");
            if (!uvm_config_db#(virtual SPI_slave_inf)::get(this, "", "vif", cfg.SPI_vif)) begin
                `uvm_fatal("SPI_slave_test", "virtual interface must be set for SPI_slave_test")
            end
            if (!uvm_config_db#(virtual SPI_slave_gm_inf)::get(this, "", "vif_gm", cfg.SPI_vif_gm)) begin
                `uvm_fatal("SPI_slave_test", "virtual interface must be set for SPI_slave_test")
            end
            uvm_config_db#(SPI_RAM_config)::set(this, "*", "SPI_slave_config_test", cfg);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            `uvm_info("SPI_slave_test", "running reset test", UVM_LOW);
            rst_sequence.start(env.agent.sequencer);
            `uvm_info("Finish_test", "reset test finished", UVM_LOW);
            #2;
            `uvm_info("SPI_slave_test", "running random test", UVM_LOW);
            random_sequence.start(env.agent.sequencer);
            `uvm_info("Finish_test", "random test finished", UVM_LOW);
            phase.drop_objection(this);
        endtask
    endclass
endpackage