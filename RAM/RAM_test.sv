package RAM_test;
import uvm_pkg::*;
import RAM_env::*;
import RAM_config::*;
import RAM_read_only_sequence::*;
import RAM_write_only_sequence::*;
import RAM_read_write_sequence::*;
import RAM_reset_sequence::*;
`include "uvm_macros.svh"
class RAM_test extends uvm_test;

`uvm_component_utils(RAM_test)
RAM_env env;
RAM_config cfg;
read_only_sequence read_seq;
write_only_sequence write_seq;
read_write_sequence read_write_seq;
reset_sequence reset_seq;

function new(string name="RAM_test", uvm_component parent=null);
    super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = RAM_env::type_id::create("env", this);
    cfg = RAM_config::type_id::create("cfg", this);
    read_seq = read_only_sequence::type_id::create("read_seq", this);
    write_seq = write_only_sequence::type_id::create("write_seq", this);
    read_write_seq = read_write_sequence::type_id::create("read_write_seq", this);
    reset_seq = reset_sequence::type_id::create("reset_seq", this);
    if(!uvm_config_db#(virtual RAM_if)::get(this, "", "vif_DUT", cfg.vif)) begin
        `uvm_fatal("NOVIF","Virtual interface must be set for:  via configuration database");
    end
    if(!uvm_config_db#(virtual RAM_if_ref)::get(this, "", "vif_REF", cfg.vif_ref)) begin
        `uvm_fatal("NOVIF","Virtual interface reference must be set for: via configuration database");
    end
    uvm_config_db#(RAM_config)::set(this, "*", "cfg", cfg);
endfunction
task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    //reset sequence
    reset_seq.start(env.agent.sequencer);
    `uvm_info("TEST", "Reset sequence completed", UVM_LOW);
    //write sequence
    write_seq.start(env.agent.sequencer);
    `uvm_info("TEST", "Write sequence completed", UVM_LOW);
    //read sequence
    read_seq.start(env.agent.sequencer);
    `uvm_info("TEST", "Read sequence completed", UVM_LOW);
    //read and write sequence
    read_write_seq.start(env.agent.sequencer);
    `uvm_info("TEST", "Read and Write sequence completed", UVM_LOW);

    phase.drop_objection(this); 
endtask


endclass
endpackage