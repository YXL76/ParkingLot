`timescale 1ns / 100ps

module LFSR_tb;

    reg rst;
    reg clk;
    reg power;
    wire [7:0] random;
    LFSR LFSRTb(rst, clk, power, random);

    initial begin
        rst = 1'b1;
        #10 rst = 1'b0;
        #5  rst = 1'b1;
    end

    initial clk = 1'b0;
    always  clk = #1 ~clk;

    initial begin
        power = 1'b0;
        #40 power = 1'b1;
    end

endmodule