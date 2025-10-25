module SPI_Slave_golden_model(SPI_slave_gm_inf.gm if_gm);

    reg [3:0] counter;
    reg       received_address;
    reg [2:0] cs, ns;

    localparam IDLE      = 3'b000;
    localparam WRITE     = 3'b001;
    localparam CHK_CMD   = 3'b010;
    localparam READ_ADD  = 3'b011;
    localparam READ_DATA = 3'b100;
    

    always @(posedge if_gm.clk) begin
        if (~if_gm.rst_n) begin 
            if_gm.rx_data <= 0;
            if_gm.rx_valid <= 0;
            received_address <= 0;
            if_gm.MISO <= 0;
            counter <= 10;
        end
        else begin
            case (cs)
                IDLE : begin
                    if_gm.rx_data <= 1;
                    if_gm.rx_valid <= 0;
                end
                CHK_CMD : begin
                    counter <= 10;
                end
                WRITE : begin
                    if (counter > 0) begin
                        if_gm.rx_data[counter-1] <= if_gm.MOSI;
                        counter <= counter - 1;
                    end
                    else begin
                        if_gm.rx_valid <= 1;
                        counter <= 8;
                    end
                end
                READ_ADD : begin
                    if (counter > 0) begin
                        if_gm.rx_data[counter-1] <= if_gm.MOSI;
                        counter <= counter - 1;
                    end
                    else begin
                        if_gm.rx_valid <= 1;
                        received_address <= 1;
                    end
                end
                READ_DATA : begin
                    if (if_gm.tx_valid) begin
                        if_gm.rx_valid <= 0;
                        if (counter > 0) begin
                            if_gm.MISO <= if_gm.tx_data[counter-1];
                            counter <= counter - 1;
                        end
                        else begin
                            received_address <= 0;
                            if_gm.rx_valid <= 1;
                        end
                    end
                    else begin
                        if (counter > 0) begin
                            if_gm.rx_data[counter-1] <= if_gm.MOSI;
                            counter <= counter - 1;
                        end
                        else begin
                            if_gm.rx_valid <= 1;
                            counter <= 8;
                        end
                    end
                end
            endcase
        end
    end

    always @(*) begin
        case (cs)
            IDLE : begin
                if (if_gm.SS_n)
                    ns = IDLE;
                else
                    ns = CHK_CMD;
            end
            CHK_CMD : begin
                if (if_gm.SS_n)
                    ns = IDLE;
                else begin
                    if (~if_gm.MOSI)
                        ns = WRITE;
                    else begin
                        if (~received_address)
                            ns = READ_ADD;
                        else
                            ns = READ_DATA;
                    end
                end
            end
            WRITE : begin
                if (if_gm.SS_n)
                    ns = IDLE;
                else
                    ns = WRITE;
            end
            READ_ADD : begin
                if (if_gm.SS_n)
                    ns = IDLE;
                else
                    ns = READ_ADD;
            end
            READ_DATA : begin
                if (if_gm.SS_n)
                    ns = IDLE;
                else
                    ns = READ_DATA;
            end
        endcase
    end

    always @(posedge if_gm.clk) begin
        if (~if_gm.rst_n) begin
            cs <= IDLE;
        end
        else begin
            cs <= ns;
        end
    end
    
endmodule