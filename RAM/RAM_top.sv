import uvm_pkg::*;
import RAM_test::*;
`include "uvm_macros.svh"
module RAM_top();
bit clk;
initial begin
      clk = 0;
      forever #1 clk = ~clk;
end
RAM_if RAM_if_inst(clk);
RAM_if_ref RAM_if_ref_inst(clk);
RAM DUT(RAM_if_inst);
RAM_ref REF(RAM_if_ref_inst);
assign RAM_if_ref_inst.din = RAM_if_inst.din;
assign RAM_if_ref_inst.rx_valid = RAM_if_inst.rx_valid;
assign RAM_if_ref_inst.rst_n = RAM_if_inst.rst_n;
bind RAM RAM_sva RAM_sva_inst(RAM_if_inst.DUT);

initial begin
      uvm_config_db#(virtual RAM_if)::set(null, "uvm_test_top", "vif_DUT", RAM_if_inst);
      uvm_config_db#(virtual RAM_if_ref)::set(null, "uvm_test_top", "vif_REF", RAM_if_ref_inst);
      run_test("RAM_test");
end

endmodule