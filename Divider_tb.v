`timescale 1ns / 100ps

module Divider_tb;

    reg clk;
    initial clk = 1'b0;
    always  clk = #1 ~clk;

    wire clk_out1;
    wire clk_out2;
    wire clk_out4;

    Divider#(.kPeriod(1)) DividerTb1(clk, clk_out1);
    Divider#(.kPeriod(2)) DividerTb2(clk, clk_out2);
    Divider#(.kPeriod(4)) DividerTb4(clk, clk_out4);

endmodule