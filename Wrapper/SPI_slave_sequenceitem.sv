package SPI_slave_sequenceitem_pkg;
    import uvm_pkg::*;
    import shared_package::*;
    `include "uvm_macros.svh"
    typedef enum bit [2:0] {
        WRITE_ADD  = 3'b000,
        WRITE_DATA = 3'b001,
        READ_ADD   = 3'b110,
        READ_DATA  = 3'b111
    } cmd_t;


    class SPI_slave_sequenceitem extends uvm_sequence_item;
        `uvm_object_utils(SPI_slave_sequenceitem)
        logic MOSI;
        rand logic [10:0] MOSI_arr;
        rand logic SS_n = 1;
        rand logic rst_n, tx_valid;
        rand logic [7:0] tx_data;
        logic [9:0] rx_data;
        logic rx_valid, MISO;

        logic [10:0] old_MOSI_arr = 3'b111;
        logic [2:0] next_mosi = 3'b000;
        int counter = 0;
        function new(string name = "SPI_slave_sequenceitem");
            super.new(name);
        endfunction

        function string convert2string();
            return $sformatf("SPI_slave_sequenceitem: %s: MOSI=%b,
            rst_n=%b, SS_n=%b, tx_valid=%b, tx_data=%b, rx_data=%b, 
            rx_valid=%b, MISO=%b",super.convert2string(), MOSI, rst_n, 
            SS_n, tx_valid, tx_data, rx_data, rx_valid, MISO);
        endfunction

        function void pre_randomize();
            if(SS_n == 0) begin
                MOSI_arr.rand_mode(0);
            end
            else begin
                MOSI_arr.rand_mode(1);
            end
        endfunction

        constraint c1 {
            rst_n dist {0:/1 , 1:/99};

            if(counter == 23 && old_MOSI_arr[10:8] == 3'b111){
                SS_n == 1;
            }
            if(counter == 13 && old_MOSI_arr[10:8] != 3'b111){
                SS_n == 1;
            }
            if(!(counter == 23 && old_MOSI_arr[10:8] == 3'b111) && !(counter == 13 && old_MOSI_arr[10:8] != 3'b111)){
                SS_n == 0;
            }

            if(old_MOSI_arr[10:8] == 3'b111){
                tx_valid == 1;
            }
        }

        function void post_randomize();
            if(rst_n == 0) begin
                counter = 0;
            end
            else begin
                if(SS_n == 0) begin
                    counter = counter + 1;
                    if(counter == 1) begin
                        MOSI_arr = {next_mosi,MOSI_arr[7:0]};
                        old_MOSI_arr = MOSI_arr;
                    end
                    if(counter > 2) begin
                        MOSI = MOSI_arr[10];
                        MOSI_arr = MOSI_arr << 1;
                    end
                end
                else begin
                    counter = 0;
                    
                    if(old_MOSI_arr[10:8] == 3'b000) begin
                        next_mosi = 3'b001;
                    end
                    else if(old_MOSI_arr[10:8] == 3'b001) begin
                        next_mosi = 3'b110;
                    end
                    else if(old_MOSI_arr[10:8] == 3'b110) begin
                        next_mosi = 3'b111;
                    end
                    else if(old_MOSI_arr[10:8] == 3'b111) begin
                        next_mosi = 3'b000;
                    end
                end
            end
        endfunction
    endclass
endpackage