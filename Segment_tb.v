`timescale 1ns / 100ps

module Segment_tb;

    reg power = 0;
    reg delay = 0;
    reg need_pay = 0;
    reg flicker_clk = 0;
    reg [5:0] count = 1;
    reg [2:0] scan_cnt = 0;
    reg [5:0] time_day = 1;
    reg [4:0] time_night = 1;
    wire [7:0] dis;
    wire [7:0] seg;
    Segment SegmentTb(power, delay, need_pay, flicker_clk, count, scan_cnt, time_day, time_night, dis, seg);

    initial begin
        #5  power = 1;
    end

    initial begin
        #50 delay = 1;
        #20 delay = 0;
    end

    initial begin
        #20 need_pay = 1;
        #30 need_pay = 0;
    end

    always  flicker_clk = #2 ~flicker_clk;

    always begin
        #1  scan_cnt = 0;
        #1  scan_cnt = 1;
        #1  scan_cnt = 2;
        #1  scan_cnt = 3;
        #1  scan_cnt = 4;
        #1  scan_cnt = 5;
        #1  scan_cnt = 6;
        #1  scan_cnt = 7;
    end

endmodule