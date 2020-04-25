`timescale 1ns / 100ps

module KeyDebounce_tb;

    reg debounce_clk = 0;
    reg key = 0;
    wire key_pulse;
    KeyDebounce KeyDebounceTb(debounce_clk, key, key_pulse);

    always debounce_clk = #15 ~debounce_clk;

    initial begin
        #1  key = 1;
        #2  key = 0;
        #1  key = 1;
        #3  key = 0;
        #1  key = 1;
        #4  key = 0;
        #1  key = 1;
        #3  key = 0;
        #1  key = 1;
        #40 key = 0;
        #1  key = 1;
        #2  key = 0;
        #1  key = 1;
        #3  key = 0;
        #1  key = 1;
        #4  key = 0;
    end

endmodule