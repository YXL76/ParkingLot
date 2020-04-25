`timescale 1ns / 100ps

module LEDControl_tb;
    
    reg power = 0;
    reg flicker = 0;
    reg [7:0] swt = 8'b1111_1111;
    reg [7:0] leave = 0;
    wire [15:0] led;
    LEDControl LEDControlTb(power, flicker, swt, leave, led);

    initial begin
        #5  power = 1;
    end

    always  flicker = #2 ~flicker;

    initial begin
        #15 swt = 8'b1111_1110;
        #5  swt = 8'b1111_1111;
        #20 swt = 8'b1111_1111;
        #20 swt = 8'b1111_1110;
    end

    initial begin
        #15 leave = 8'b0000_0000;
        #5  leave = 8'b0000_0001;
        #20 leave = 8'b0000_0000;
    end

endmodule