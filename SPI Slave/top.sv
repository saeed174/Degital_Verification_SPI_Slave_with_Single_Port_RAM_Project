`include "uvm_macros.svh"
import uvm_pkg::*;
import SPI_slave_test_pkg::*;
module top;

    bit clk;
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    SPI_slave_inf if_c(.clk(clk));
    SPI_slave_gm_inf if_gm(.clk(clk));
    SPI_slave SPI_slave_inst(if_c);
    SPI_Slave_golden_model gm(if_gm);
    SPI_slave_sva sva(if_c);
    // bind SPI_slave SPI_slave_sva sva(if_c);
    initial begin
        uvm_config_db #(virtual SPI_slave_inf)::set(null, "uvm_test_top", "vif", if_c);
        uvm_config_db #(virtual SPI_slave_gm_inf)::set(null, "uvm_test_top", "vif_gm", if_gm);
        run_test("SPI_slave_test");
    end
endmodule
