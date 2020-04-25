/**
  * @desc 数码管显示模块
  * @input wire power - 系统开关
  * @input wire delay - 延时状态
  * @input wire need_pay - 缴费状态
  * @input wire flicker_clk - 闪烁时钟
  * @input wire [5:0] count - 点阵显示的数字
  * @input wire [2:0] scan_cnt - 扫描计数
  * @input wire [5:0] time_day - 白天停车时间
  * @input wire [4:0] time_night - 夜晚停车时间
  * @ouput reg [7:0] dis - 数码管位置
  * @ouput reg [7:0] seg - 数码管管脚
*/
module Segment (
    input power,
    input delay,
    input need_pay,
    input flicker_clk,
    input [5:0] count,
    input [2:0] scan_cnt,
    input [5:0] time_day,
    input [4:0] time_night,
    output reg [7:0] dis = 0,
    output reg [7:0] seg = 0
);

    always @(*) begin
        if (power) begin
            if (delay && flicker_clk) begin     // 当系统处于延时状态时，闪烁
                case (scan_cnt)
                    6 :       dis <= ~8'b0100_0000;
                    7 :       dis <= ~8'b1000_0000;
                    default : dis <= ~8'b0000_0000;
                endcase
            end
            else begin
                case (scan_cnt)
                    0 :       dis <= ~8'b0000_0001;
                    1 :       dis <= ~8'b0000_0010;
                    3 :       dis <= ~8'b0000_1000;
                    4 :       dis <= ~8'b0001_0000;
                    6 :       dis <= ~8'b0100_0000;
                    7 :       dis <= ~8'b1000_0000;
                    default : dis <= ~8'b0000_0000;
                endcase
            end
        end
        else                  dis <= ~8'b0000_0000;
    end

    reg [7:0] kSeg [9:0];
    initial begin
        kSeg[0] = 8'b1111_1100;
        kSeg[1] = 8'b0110_0000;
        kSeg[2] = 8'b1101_1010;
        kSeg[3] = 8'b1111_0010;
        kSeg[4] = 8'b0110_0110;
        kSeg[5] = 8'b1011_0110;
        kSeg[6] = 8'b1011_1110;
        kSeg[7] = 8'b1110_0000;
        kSeg[8] = 8'b1111_1110;
        kSeg[9] = 8'b1111_0110;
    end

    // 计算总时间和总金额
    wire [5:0] whole_time = time_day + time_night;
    wire [6:0] whole_money = time_day * 7'd2 + time_night;

    always @(*) begin
        // 当系统处于待缴费状态时以及延时状态时，34显示时间，01显示金额
        if (delay || need_pay) begin
            case (scan_cnt)
                7 :       seg <= kSeg[count / 10];
                6 :       seg <= kSeg[count % 10];
                4 :       seg <= kSeg[whole_time / 10];
                3 :       seg <= kSeg[whole_time % 10];
                1 :       seg <= kSeg[whole_money / 10];
                0 :       seg <= kSeg[whole_money % 10];
                default : seg <= kSeg[0];
            endcase
        end
        else begin
            case (scan_cnt)
                7 :       seg <= kSeg[count / 10];
                6 :       seg <= kSeg[count % 10];
                default : seg <= kSeg[0];
            endcase
        end
    end

endmodule