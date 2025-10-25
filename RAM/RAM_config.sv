package RAM_config;
import uvm_pkg::*;
`include "uvm_macros.svh"
class RAM_config extends uvm_object;
`uvm_object_utils(RAM_config)
virtual RAM_if vif;
virtual RAM_if_ref vif_ref;
 function new(string name="RAM_config");
     super.new(name);
 endfunction
 endclass
 endpackage