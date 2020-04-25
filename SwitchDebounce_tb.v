`timescale 1ns / 100ps

module SwitchDebounce_tb;

    reg clk = 0;
    reg debounce_clk = 0;
    reg [7:0] swt = 0;
    wire [7:0] de_swt;
    SwitchDebounce SwitchDebounceTb(clk, debounce_clk, swt, de_swt);

    always clk = #1 ~clk;
    always debounce_clk = #15 ~debounce_clk;

    initial begin
        #1  swt[0] = 1;
        #2  swt[0] = 0;
        #1  swt[0] = 1;
        #3  swt[0] = 0;
        #1  swt[0] = 1;
        #4  swt[0] = 0;
        #1  swt[0] = 1;
        #3  swt[0] = 0;
        #1  swt[0] = 1;
        #40 swt[0] = 0;
        #1  swt[0] = 1;
        #2  swt[0] = 0;
        #1  swt[0] = 1;
        #3  swt[0] = 0;
        #1  swt[0] = 1;
        #4  swt[0] = 0;
    end

endmodule