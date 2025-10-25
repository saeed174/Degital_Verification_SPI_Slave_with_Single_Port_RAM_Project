package SPI_slave_env_pkg;
    import uvm_pkg::*;
    import SPI_slave_agent_pkg::*;
    import SPI_slave_coverage_pkg::*;
    import SPI_slave_scoreboard_pkg::*;
    `include "uvm_macros.svh"
    class SPI_slave_env extends uvm_env;
        `uvm_component_utils(SPI_slave_env)
        SPI_slave_scoreboard scoreboard;
        SPI_slave_coverage coverage;
        SPI_slave_agent agent;
        function new(string name = "SPI_slave_env", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            agent = SPI_slave_agent::type_id::create("agent", this);
            scoreboard = SPI_slave_scoreboard::type_id::create("scoreboard", this);
            coverage = SPI_slave_coverage::type_id::create("coverage", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            agent.agt_ap.connect(coverage.cv_export);
            agent.agt_ap.connect(scoreboard.sb_export);
            agent.agt_ap_gm.connect(scoreboard.sb_export_gm);
        endfunction
    endclass
endpackage