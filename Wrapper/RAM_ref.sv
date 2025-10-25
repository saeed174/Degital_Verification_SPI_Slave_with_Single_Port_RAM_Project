module RAM_ref (RAM_if_ref.dut REF_if);

logic [7:0] MEM [255:0];
logic [7:0] Rd_Addr, Wr_Addr;

always @(posedge REF_if.clk) begin
    if (~REF_if.rst_n) begin
        REF_if.dout <= 0;
        REF_if.tx_valid <= 0;
        Rd_Addr <= 0;
        Wr_Addr <= 0;
    end
    else  begin                                         
        if (REF_if.rx_valid) begin
            case (REF_if.din[9:8])
                2'b00 : Wr_Addr <= REF_if.din[7:0];
                2'b01 : MEM[Wr_Addr] <= REF_if.din[7:0];
                2'b10 : Rd_Addr <= REF_if.din[7:0];
                2'b11 : REF_if.dout <= MEM[Rd_Addr];
                default : REF_if.dout <= 0;
            endcase
        end
        REF_if.tx_valid <= (REF_if.din[9] && REF_if.din[8])? 1'b1 : 1'b0;
        end
end

endmodule