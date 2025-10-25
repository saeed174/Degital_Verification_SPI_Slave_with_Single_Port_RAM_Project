`include "uvm_macros.svh"
import uvm_pkg::*;
import Wrapper_test_pkg::*;
module top;

    bit clk;
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    SPI_slave_inf if_c(.clk(clk));
    SPI_slave_gm_inf if_gm(.clk(clk));
    Wrapper_inf if_wrapper(.clk(clk));
    Wrapper_gm_inf wrapper_inf_gm(.clk(clk));
    RAM_if if_ram(.clk(clk));
    RAM_if_ref RAM_if_ref_inst(.clk(clk));

    Wrapper_golden_model Wrapper_golden_model_inst(wrapper_inf_gm, if_gm, RAM_if_ref_inst);

    Wrapper Wrapper_inst(if_wrapper, if_c, if_ram);

    Wrapper_sva     sva_Wrapper(if_wrapper);
    RAM_sva         sva_RAM(if_ram);
    SPI_slave_sva   sva_SPI_slave(if_c);

    initial begin
        uvm_config_db #(virtual SPI_slave_inf)::set(null, "uvm_test_top", "vif", if_c);
        uvm_config_db #(virtual SPI_slave_gm_inf)::set(null, "uvm_test_top", "vif_gm", if_gm);

        uvm_config_db#(virtual RAM_if)::set(null, "uvm_test_top", "vif_DUT", if_ram);
        uvm_config_db#(virtual RAM_if_ref)::set(null, "uvm_test_top", "vif_REF", RAM_if_ref_inst);

        uvm_config_db#(virtual Wrapper_inf)::set(null, "uvm_test_top", "wrap_vif", if_wrapper);
        uvm_config_db#(virtual Wrapper_gm_inf)::set(null, "uvm_test_top", "wrap_ref", wrapper_inf_gm);

        run_test("Wrapper_test");
    end
endmodule
