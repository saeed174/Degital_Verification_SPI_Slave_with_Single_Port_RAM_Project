package Wrapper_sequenceitem_pkg;
    import uvm_pkg::*;
    import shared_package::*;
    `include "uvm_macros.svh"
    typedef enum bit [2:0] {
        WRITE_ADD  = 3'b000,
        WRITE_DATA = 3'b001,
        READ_ADD   = 3'b110,
        READ_DATA  = 3'b111
    } cmd_t;

    class Wrapper_sequenceitem extends uvm_sequence_item;
        `uvm_object_utils(Wrapper_sequenceitem)
        // number of transactions
        cmd_t cmd_seq_old = WRITE_ADD;
        rand cmd_t cmd_seq = WRITE_DATA;
        rand bit [10:0] MOSI_arr;
        logic [10:0] old_MOSI_arr = 11'b11100000000;
        rand logic SS_n = 1;
        rand logic rst_n;
        logic MOSI;
        logic MISO;

        int counter = 0;
        bit [10:0] active_MOSI_word;

        function new(string name = "Wrapper_sequenceitem");
            super.new(name);
        endfunction

        function string convert2string();
            return $sformatf("Wrapper_sequenceitem: %s: MOSI=%b, rst_n=%b, SS_n=%b",super.convert2string(), MOSI, rst_n, SS_n);
        endfunction

        function void pre_randomize();
            if(SS_n == 0) begin
                MOSI_arr.rand_mode(0);
                ordering_rules.constraint_mode(0);
                cmd_seq.rand_mode(0);
            end
            else begin
                MOSI_arr.rand_mode(1);
                ordering_rules.constraint_mode(1);
                cmd_seq.rand_mode(1);
            end
        endfunction

        // constraint size_c {
        //     N inside {[5000:10000]};
        //     cmd_seq.size() == N;
        // }
        constraint ordering_rules {
                
            if(cmd_seq_old == WRITE_ADD){
                cmd_seq inside {WRITE_ADD, WRITE_DATA};
            }
            else if(cmd_seq_old == WRITE_DATA){
                cmd_seq dist {READ_ADD:= 60,WRITE_ADD:= 40};
            }
            else if(cmd_seq_old == READ_ADD){
                cmd_seq == READ_DATA;
            }
            else if(cmd_seq_old == READ_DATA){
                cmd_seq dist {WRITE_ADD:= 60,READ_ADD:= 40};
            }
        }


        // Random payload for remaining bits
        constraint payload {
            MOSI_arr[7:0] inside {[8'h00 : 8'hFF]};
        }

        constraint c1 {
            rst_n dist {0 := 1, 1 := 99};

            if(counter == 23 && old_MOSI_arr[10:8] == 3'b111){
                SS_n == 1;
            }
            if(counter == 13 && old_MOSI_arr[10:8] != 3'b111){
                SS_n == 1;
            }
            if(!(counter == 23 && old_MOSI_arr[10:8] == 3'b111) && !(counter == 13 && old_MOSI_arr[10:8] != 3'b111)){
                SS_n == 0;
            }
        }

        function void post_randomize();
            if (rst_n == 0) begin
                counter = 0;
                SS_n = 1;
            end
            else begin
                // === SPI active (chip selected) ===
                if (SS_n == 0) begin
                    if(counter == 0) begin
                        MOSI_arr = {cmd_seq, MOSI_arr[7:0]};
                        active_MOSI_word = MOSI_arr;
                        old_MOSI_arr = active_MOSI_word;
                        cmd_seq_old = cmd_seq;
                    end
                    else if(counter > 0) begin
                        MOSI = active_MOSI_word[10];
                        
                        active_MOSI_word = active_MOSI_word << 1;
                    end
                    counter++;
                end
                else begin
                    counter = 0;
                end
            end
            $display("MOSI : %b",MOSI);
            $display("MOSI_word : %b",old_MOSI_arr);
            $display("cmd_seq : %b",cmd_seq);
        endfunction

    endclass
endpackage