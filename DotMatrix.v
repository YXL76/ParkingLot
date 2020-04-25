/**
  * @desc 点阵显示模块 - 点阵在信号的控制下显示数字
  * @input wire power - 系统开关
  * @input wire enable - 使能
  * @input wire [3:0] num - 点阵显示的数字
  * @input wire [2:0] scan_cnt - 扫描计数
  * @ouput reg [7 : 0] row - 点阵行
  * @ouput reg [7 : 0] col_r - 点阵列（红色）
  * @ouput reg [7 : 0] col_g - 点阵列（绿色）
*/
module DotMatrix (
    input power,
    input enable,
    input [3:0] num,
    input [2:0] scan_cnt,
    output reg [7 : 0] row,
    output reg [7 : 0] col_r,
    output reg [7 : 0] col_g
);

    // 扫描行
    always @(*) begin
        if (enable && power)       // 只有当系统开启和使能为1时显示
            case (scan_cnt)
                0 :       row <= 8'b1111_1110;
                1 :       row <= 8'b1111_1101;
                2 :       row <= 8'b1111_1011;
                3 :       row <= 8'b1111_0111;
                4 :       row <= 8'b1110_1111;
                5 :       row <= 8'b1101_1111;
                6 :       row <= 8'b1011_1111;
                7 :       row <= 8'b0111_1111;
                default : row <= 8'b1111_1111;
            endcase
        else              row <= 8'b1111_1111;
    end

    // 根据要显示的数字扫描列
    always @(*) begin
        if (enable && power) begin // 只有当系统开启和使能为1时显示
            case (num)
                0 : case (scan_cnt)
                    1 :       begin col_r <= 8'b0001_1100; col_g <= 8'b0001_1100; end
                    2 :       begin col_r <= 8'b0010_0010; col_g <= 8'b0010_0010; end
                    3 :       begin col_r <= 8'b0010_0010; col_g <= 8'b0010_0010; end
                    4 :       begin col_r <= 8'b0010_0010; col_g <= 8'b0010_0010; end
                    5 :       begin col_r <= 8'b0010_0010; col_g <= 8'b0010_0010; end
                    6 :       begin col_r <= 8'b0010_0010; col_g <= 8'b0010_0010; end
                    7 :       begin col_r <= 8'b0001_1100; col_g <= 8'b0001_1100; end
                    default : begin col_r <= 8'b0000_0000; col_g <= 8'b0000_0000; end
                endcase
                1 :   case (scan_cnt)
                    1 :       begin col_r <= 8'b0000_0100; col_g <= 8'b0000_0100; end
                    2 :       begin col_r <= 8'b0000_1100; col_g <= 8'b0000_1100; end
                    3 :       begin col_r <= 8'b0000_0100; col_g <= 8'b0000_0100; end
                    4 :       begin col_r <= 8'b0000_0100; col_g <= 8'b0000_0100; end
                    5 :       begin col_r <= 8'b0000_0100; col_g <= 8'b0000_0100; end
                    6 :       begin col_r <= 8'b0000_0100; col_g <= 8'b0000_0100; end
                    7 :       begin col_r <= 8'b0000_1110; col_g <= 8'b0000_1110; end
                    default : begin col_r <= 8'b0000_0000; col_g <= 8'b0000_0000; end
                endcase
                2 : case (scan_cnt)
                    1 :       begin col_r <= 8'b0001_1100; col_g <= 8'b0001_1100; end
                    2 :       begin col_r <= 8'b0010_0010; col_g <= 8'b0010_0010; end
                    3 :       begin col_r <= 8'b0000_0010; col_g <= 8'b0000_0010; end
                    4 :       begin col_r <= 8'b0000_0010; col_g <= 8'b0000_0010; end
                    5 :       begin col_r <= 8'b0011_1100; col_g <= 8'b0011_1100; end
                    6 :       begin col_r <= 8'b0010_0000; col_g <= 8'b0010_0000; end
                    7 :       begin col_r <= 8'b0011_1110; col_g <= 8'b0011_1110; end
                    default : begin col_r <= 8'b0000_0000; col_g <= 8'b0000_0000; end
                endcase
                3 : case (scan_cnt)
                    1 :       begin col_r <= 8'b0001_1100; col_g <= 8'b0001_1100; end
                    2 :       begin col_r <= 8'b0010_0010; col_g <= 8'b0010_0010; end
                    3 :       begin col_r <= 8'b0000_0010; col_g <= 8'b0000_0010; end
                    4 :       begin col_r <= 8'b0001_1100; col_g <= 8'b0001_1100; end
                    5 :       begin col_r <= 8'b0000_0010; col_g <= 8'b0000_0010; end
                    6 :       begin col_r <= 8'b0010_0010; col_g <= 8'b0010_0010; end
                    7 :       begin col_r <= 8'b0001_1100; col_g <= 8'b0001_1100; end
                    default : begin col_r <= 8'b0000_0000; col_g <= 8'b0000_0000; end
                endcase
                4 : case (scan_cnt)
                    1 :       begin col_r <= 8'b0000_0100; col_g <= 8'b0000_0100; end
                    2 :       begin col_r <= 8'b0000_1100; col_g <= 8'b0000_1100; end
                    3 :       begin col_r <= 8'b0001_0100; col_g <= 8'b0001_0100; end
                    4 :       begin col_r <= 8'b0010_0100; col_g <= 8'b0010_0100; end
                    5 :       begin col_r <= 8'b0011_1110; col_g <= 8'b0011_1110; end
                    6 :       begin col_r <= 8'b0000_0100; col_g <= 8'b0000_0100; end
                    7 :       begin col_r <= 8'b0000_0100; col_g <= 8'b0000_0100; end
                    default : begin col_r <= 8'b0000_0000; col_g <= 8'b0000_0000; end
                endcase
                5 : case (scan_cnt)
                    1 :       begin col_r <= 8'b0011_1110; col_g <= 8'b0011_1110; end
                    2 :       begin col_r <= 8'b0010_0000; col_g <= 8'b0010_0000; end
                    3 :       begin col_r <= 8'b0011_1100; col_g <= 8'b0011_1100; end
                    4 :       begin col_r <= 8'b0000_0010; col_g <= 8'b0000_0010; end
                    5 :       begin col_r <= 8'b0000_0010; col_g <= 8'b0000_0010; end
                    6 :       begin col_r <= 8'b0010_0010; col_g <= 8'b0010_0010; end
                    7 :       begin col_r <= 8'b0001_1100; col_g <= 8'b0001_1100; end
                    default : begin col_r <= 8'b0000_0000; col_g <= 8'b0000_0000; end
                endcase
                6 : case (scan_cnt)
                    1 :       begin col_r <= 8'b0001_1100; col_g <= 8'b0001_1100; end
                    2 :       begin col_r <= 8'b0010_0010; col_g <= 8'b0010_0010; end
                    3 :       begin col_r <= 8'b0010_0000; col_g <= 8'b0010_0000; end
                    4 :       begin col_r <= 8'b0011_1100; col_g <= 8'b0011_1100; end
                    5 :       begin col_r <= 8'b0010_0010; col_g <= 8'b0010_0010; end
                    6 :       begin col_r <= 8'b0010_0010; col_g <= 8'b0010_0010; end
                    7 :       begin col_r <= 8'b0001_1100; col_g <= 8'b0001_1100; end
                    default : begin col_r <= 8'b0000_0000; col_g <= 8'b0000_0000; end
                endcase
                7 : case (scan_cnt)
                    1 :       begin col_r <= 8'b0011_1110; col_g <= 8'b0011_1110; end
                    2 :       begin col_r <= 8'b0000_0010; col_g <= 8'b0000_0010; end
                    3 :       begin col_r <= 8'b0000_0010; col_g <= 8'b0000_0010; end
                    4 :       begin col_r <= 8'b0000_0100; col_g <= 8'b0000_0100; end
                    5 :       begin col_r <= 8'b0000_0100; col_g <= 8'b0000_0100; end
                    6 :       begin col_r <= 8'b0000_0100; col_g <= 8'b0000_0100; end
                    7 :       begin col_r <= 8'b0000_0100; col_g <= 8'b0000_0100; end
                    default : begin col_r <= 8'b0000_0000; col_g <= 8'b0000_0000; end
                endcase
                8 : case (scan_cnt)
                    1 :       begin col_r <= 8'b0001_1100; col_g <= 8'b0001_1100; end
                    2 :       begin col_r <= 8'b0010_0010; col_g <= 8'b0010_0010; end
                    3 :       begin col_r <= 8'b0010_0010; col_g <= 8'b0010_0010; end
                    4 :       begin col_r <= 8'b0001_1100; col_g <= 8'b0001_1100; end
                    5 :       begin col_r <= 8'b0010_0010; col_g <= 8'b0010_0010; end
                    6 :       begin col_r <= 8'b0010_0010; col_g <= 8'b0010_0010; end
                    7 :       begin col_r <= 8'b0001_1100; col_g <= 8'b0001_1100; end
                    default : begin col_r <= 8'b0000_0000; col_g <= 8'b0000_0000; end
                endcase
                default :     begin col_r <= 8'b0000_0000; col_g <= 8'b0000_0000; end
            endcase
        end
        else                  begin col_r <= 8'b0000_0000; col_g <= 8'b0000_0000; end
    end

endmodule