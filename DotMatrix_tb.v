`timescale 1ns / 100ps

module DotMatrix_tb;

    reg power = 0;
    reg enable = 0;
    reg [3:0] num = 8;
    reg [2:0] scan_cnt = 0;
    wire [7:0] row;
    wire [7:0] col_r;
    wire [7:0] col_g;
    DotMatrix DotMatrixTb(power, enable, num, scan_cnt, row, col_r, col_g);

    initial begin
        #5 power = 1;
    end

    initial begin
        #5  enable = 1;
        #20 enable = 0;
        #2  enable = 1;
        #2  enable = 0;
        #2  enable = 1;
        #2  enable = 0;
        #2  enable = 1;
    end

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