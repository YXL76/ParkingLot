`timescale 1ns / 100ps

module LCD_tb;
    
    reg rst = 1;
    reg clk = 0;
    reg scan_clk = 0;
    reg power = 0;
    reg [3:0] car = 2;
    reg [5:0] time_cnt = 2;
    wire RW;
    wire EN;
    wire RS;
    wire [7:0] data_bus;
    LCD LCDDisplay(rst, clk, scan_clk, power, car, time_cnt, RW, EN, RS, data_bus);

    initial #5  power = 1;

    always  clk = #1 ~clk;
    always  scan_clk = #20 ~scan_clk;

endmodule