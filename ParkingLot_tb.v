`timescale 1ns / 100ps

module ParkingLot_tb;

    reg rst = 1;
    reg clk = 0;
    reg pow = 0;
    reg pay = 0;
    reg [7:0] swt = 8'b0000_0000;
    wire buz;
    wire [7:0] row;
    wire [7:0] col_r;
    wire [7:0] col_g;
    wire [7:0] dis;
    wire [7:0] seg;
    wire [15:0] led;
    ParkingLot ParkingLotTb(rst, clk, pow, pay, swt, buz, row, col_r, col_g, dis, seg, led);

    always  clk = #1 ~clk;

    initial begin
        #5  pow = 1;
        #5  pow = 0;
    end
    
    initial begin
        #300 pay = 1;
        #5  pay = 0;
    end
    
    initial begin
        #50 swt = 8'b0000_0001;
        #200 swt = 8'b0000_0000;
    end

endmodule