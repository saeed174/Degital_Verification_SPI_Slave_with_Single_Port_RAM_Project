package RAM_env;
import uvm_pkg::*;
import RAM_seq_item::*;
import RAM_agent::*;
import RAM_scoreboard::*;
import RAM_coverage::*;
import RAM_monitor_ref::*;
`include "uvm_macros.svh"
class RAM_env extends uvm_env;
`uvm_component_utils(RAM_env)
RAM_agent agent;
RAM_scoreboard sb;
RAM_monitor_ref mon_ref;
RAM_coverage cov;
function new(string name="RAM_env", uvm_component parent=null);
    super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = RAM_agent::type_id::create("agent", this);
    sb = RAM_scoreboard::type_id::create("sb", this);
    cov = RAM_coverage::type_id::create("cov", this);
    mon_ref = RAM_monitor_ref::type_id::create("mon_ref", this);
endfunction
function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent.agent_ap.connect(sb.sb_export);
    agent.agent_ap.connect(cov.cov_export);
    mon_ref.mon_ref_ap.connect(sb.sb_export_ref);
endfunction

endclass
endpackage