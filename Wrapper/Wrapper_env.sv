package Wrapper_env_pkg;
    import uvm_pkg::*;
    import Wrapper_agent_pkg::*;
    import Wrapper_scoreboard_pkg::*;
    `include "uvm_macros.svh"
    class Wrapper_env extends uvm_env;
        `uvm_component_utils(Wrapper_env)
        Wrapper_scoreboard scoreboard;
        Wrapper_agent agent;
        function new(string name = "Wrapper_env", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            agent = Wrapper_agent::type_id::create("agent", this);
            scoreboard = Wrapper_scoreboard::type_id::create("scoreboard", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            agent.agt_ap.connect(scoreboard.sb_export);
            agent.agt_ap_gm.connect(scoreboard.sb_export_gm);
        endfunction
    endclass
endpackage