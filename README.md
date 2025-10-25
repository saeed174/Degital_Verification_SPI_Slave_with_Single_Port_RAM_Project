# 🧠 SPI Wrapper Verification Project – UVM Environment

Welcome to the **Verification Environment for the SPI Wrapper Module**!  
This repository contains a complete **UVM**-based verification setup for the **Single-Port SPI Module with RAM**.  
It validates correct SPI operation, memory access, and protocol compliance using **SystemVerilog** and **QuestaSim**.

---

## 🔍 High-Level Overview

The DUT (Design Under Test) is an SPI slave that interfaces with internal RAM and handles serial–parallel data conversion.  
This verification environment ensures that the design:

- Correctly implements SPI protocol (MOSI, MISO, SS_n, clk)
- Performs accurate RAM read/write operations
- Maintains data integrity under different timing and transaction scenarios
- Handles error conditions (invalid commands, overflow, etc.)

**Key modules in `top.sv`:**

- `SPI_slave_inf if_c(.clk(clk));` — main interface used by the DUT/testbench  
- `SPI_slave_gm_inf if_gm(.clk(clk));` — interface for the golden model  
- `SPI_slave SPI_slave_inst(if_c);` — DUT instance  
- `SPI_Slave_golden_model gm(if_gm);` — golden reference model  
- `SPI_slave_sva sva(if_c);` — SVA checker module for assertions  

**Test entry point:**  
```systemverilog
uvm_config_db#(virtual SPI_slave_inf)::set(null, "uvm_test_top", "vif", if_c);
uvm_config_db#(virtual SPI_slave_gm_inf)::set(null, "uvm_test_top", "vif_gm", if_gm);
run_test("SPI_slave_test");
