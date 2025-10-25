module SPI_slave(SPI_slave_inf.dut if_c);

    localparam IDLE      = 3'b000;
    localparam CHK_CMD   = 3'b001;
    localparam WRITE     = 3'b010;
    localparam READ_ADD  = 3'b011;
    localparam READ_DATA = 3'b100;

    reg [3:0] counter;
    reg       received_address;

    reg [2:0] cs, ns;

    always @(posedge if_c.clk) begin
        if (~if_c.rst_n) begin
            cs <= IDLE;
        end
        else begin
            cs <= ns;
        end
    end

    always @(*) begin
        case (cs)
            IDLE : begin
                if (if_c.SS_n)
                    ns = IDLE;
                else
                    ns = CHK_CMD;
            end
            CHK_CMD : begin
                if (if_c.SS_n)
                    ns = IDLE;
                else begin
                    if (~if_c.MOSI)
                        ns = WRITE;
                    else begin
                        if (~received_address) //fix
                            ns = READ_ADD;
                        else
                            ns = READ_DATA;
                    end
                end
            end
            WRITE : begin
                if (if_c.SS_n)
                    ns = IDLE;
                else
                    ns = WRITE;
            end
            READ_ADD : begin
                if (if_c.SS_n)
                    ns = IDLE;
                else
                    ns = READ_ADD;
            end
            READ_DATA : begin
                if (if_c.SS_n)
                    ns = IDLE;
                else
                    ns = READ_DATA;
            end
        endcase
    end

    always @(posedge if_c.clk) begin
        if (~if_c.rst_n) begin 
            if_c.rx_data <= 0;
            if_c.rx_valid <= 0;
            received_address <= 0;
            if_c.MISO <= 0;
            counter <= 10;
        end
        else begin
            case (cs)
                IDLE : begin
                    if_c.rx_data <= 1;
                    if_c.rx_valid <= 0;
                end
                CHK_CMD : begin
                    counter <= 10;
                end
                WRITE : begin
                    if (counter > 0) begin
                        if_c.rx_data[counter-1] <= if_c.MOSI;
                        counter <= counter - 1;
                    end
                    else begin
                        if_c.rx_valid <= 1;
                        counter <= 8;
                    end
                end
                READ_ADD : begin
                    if (counter > 0) begin
                        if_c.rx_data[counter-1] <= if_c.MOSI;
                        counter <= counter - 1;
                    end
                    else begin
                        if_c.rx_valid <= 1;
                        received_address <= 1;
                    end
                end
                default : begin
                    if (if_c.tx_valid) begin
                        if_c.rx_valid <= 0;
                        if (counter > 0) begin
                            if_c.MISO <= if_c.tx_data[counter-1];
                            counter <= counter - 1;
                        end
                        else begin
                            received_address <= 0;
                            if_c.rx_valid <= 1; // fix
                        end
                    end
                    else begin
                        if (counter > 0) begin
                            if_c.rx_data[counter-1] <= if_c.MOSI;
                            counter <= counter - 1;
                        end
                        else begin
                            if_c.rx_valid <= 1;
                            counter <= 8;
                        end
                    end
                end
            endcase
        end
    end

    `ifdef SIM

    property p_state_operation_1;

        @(posedge if_c.clk) disable iff(~if_c.rst_n)
        (cs == IDLE) |=> (cs == IDLE || cs == CHK_CMD)
    endproperty
    assert  property(p_state_operation_1);
    cover   property(p_state_operation_1);

    property p_state_operation_2;

        @(posedge if_c.clk) disable iff(~if_c.rst_n)
        (cs == CHK_CMD) |=> (cs == IDLE || cs == WRITE || cs == READ_ADD || cs == READ_DATA)
    endproperty
    assert  property(p_state_operation_2);
    cover   property(p_state_operation_2);

    property p_state_operation_3;

        @(posedge if_c.clk) disable iff(~if_c.rst_n)
        (cs == WRITE) |=> (cs == WRITE || cs == IDLE)
    endproperty
    assert  property(p_state_operation_3);
    cover   property(p_state_operation_3);

    property p_state_operation_4;
        @(posedge if_c.clk) disable iff(~if_c.rst_n)
        (cs == READ_ADD) |=> (cs == READ_ADD || cs == IDLE)
    endproperty
    assert  property(p_state_operation_4);
    cover   property(p_state_operation_4);

    property p_state_operation_5;
        @(posedge if_c.clk) disable iff(~if_c.rst_n)
        (cs == READ_DATA) |=> (cs == READ_DATA || cs == IDLE)
    endproperty
    assert  property(p_state_operation_5);
    cover   property(p_state_operation_5);

`endif

endmodule