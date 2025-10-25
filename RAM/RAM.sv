module RAM (RAM_if.DUT DUT_if);

logic[7:0] MEM [255:0];
logic [7:0] Rd_Addr, Wr_Addr;

always @(posedge DUT_if.clk) begin
    if (~DUT_if.rst_n) begin
        DUT_if.dout <= 0;
        DUT_if.tx_valid <= 0;
        Rd_Addr <= 0;
        Wr_Addr <= 0;
    end
    else  begin                                         
        if (DUT_if.rx_valid) begin
            case (DUT_if.din[9:8])
                2'b00 : Wr_Addr <= DUT_if.din[7:0];
                2'b01 : MEM[Wr_Addr] <= DUT_if.din[7:0];
                2'b10 : Rd_Addr <= DUT_if.din[7:0];
                2'b11 : DUT_if.dout <= MEM[Rd_Addr];
                default : DUT_if.dout <= 0;
            endcase
        end
        DUT_if.tx_valid <= (DUT_if.din[9] && DUT_if.din[8] && DUT_if.rx_valid)? 1'b1 : 1'b0;
        end
end

endmodule