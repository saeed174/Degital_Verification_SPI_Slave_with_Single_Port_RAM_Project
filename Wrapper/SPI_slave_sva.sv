module SPI_slave_sva(SPI_slave_inf.dut if_c);

    localparam IDLE      = 3'b000;
    localparam CHK_CMD   = 3'b001;
    localparam WRITE     = 3'b010;
    localparam READ_ADD  = 3'b011;
    localparam READ_DATA = 3'b100;

    
    property p_reset;
        @(posedge if_c.clk)
        (~if_c.rst_n |=> (if_c.MISO == 'b0 && if_c.rx_valid == 'b0 && if_c.rx_data == 'b0))
    endproperty
    assert  property(p_reset);
    cover   property(p_reset);

    property p_rx_valid_SS_n_operation_write_add;
        @(posedge if_c.clk) disable iff(~if_c.rst_n)
        (if_c.SS_n ##1 !if_c.SS_n ##1 (!if_c.MOSI ##1 !if_c.MOSI ##1 !if_c.MOSI)) |-> ##10 ($rose(if_c.rx_valid)) ##[1:$] if_c.SS_n;
    endproperty
    assert  property(p_rx_valid_SS_n_operation_write_add);
    cover   property(p_rx_valid_SS_n_operation_write_add);

    property p_rx_valid_SS_n_operation_write_data;
        @(posedge if_c.clk) disable iff(~if_c.rst_n)
        (if_c.SS_n ##1 !if_c.SS_n ##1 (!if_c.MOSI ##1 !if_c.MOSI ##1 if_c.MOSI)) |-> ##10 ($rose(if_c.rx_valid)) ##[1:$] if_c.SS_n;
    endproperty
    assert  property(p_rx_valid_SS_n_operation_write_data);
    cover   property(p_rx_valid_SS_n_operation_write_data);

    property p_rx_valid_SS_n_operation_read_add;
        @(posedge if_c.clk) disable iff(~if_c.rst_n)
        (if_c.SS_n ##1 !if_c.SS_n ##1 if_c.MOSI ##1 if_c.MOSI ##1 !if_c.MOSI) |-> ##10 ($rose(if_c.rx_valid)) ##[1:$] if_c.SS_n;
    endproperty
    assert  property(p_rx_valid_SS_n_operation_read_add);
    cover   property(p_rx_valid_SS_n_operation_read_add);

    property p_rx_valid_SS_n_operation_read_data;
        @(posedge if_c.clk) disable iff(~if_c.rst_n)
        (if_c.SS_n ##1 !if_c.SS_n ##1 if_c.MOSI ##1 if_c.MOSI ##1 if_c.MOSI) |-> ##10 ($rose(if_c.rx_valid)) ##[1:$] if_c.SS_n;
    endproperty
    assert  property(p_rx_valid_SS_n_operation_read_data);
    cover   property(p_rx_valid_SS_n_operation_read_data);

endmodule : SPI_slave_sva