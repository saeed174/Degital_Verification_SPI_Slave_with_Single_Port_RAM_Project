module Wrapper_sva (Wrapper_inf.dut if_wrapper);

    property p_reset;
        @(posedge if_wrapper.clk)
        (~if_wrapper.rst_n |=> (if_wrapper.MISO == 'b0))
    endproperty
    assert  property(p_reset);
    cover   property(p_reset);

    property MISO_stable_when_not_read;
        @(posedge if_wrapper.clk)
        disable iff (!if_wrapper.rst_n)    // disable when reset active or slave not selected
        (if_wrapper.SS_n ## 1 !if_wrapper.SS_n ## 1 (if_wrapper.MOSI ## 1 if_wrapper.MOSI ## 1 if_wrapper.MOSI)) |=> $stable(if_wrapper.MISO) throughout (!if_wrapper.SS_n);
    endproperty

    assert  property(MISO_stable_when_not_read);
    cover   property(MISO_stable_when_not_read);
endmodule