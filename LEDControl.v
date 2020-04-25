/**
  * @desc LED控制模块 - 由信号控制LED的亮暗
  * @input wire power - 系统开关
  * @input wire flicker - 闪烁使能
  * @input wire [7:0] swt - 拨码按键状态
  * @input wire [7:0] leave - 当前驶离车辆
  * @ouput reg [15:0] led - LED灯
*/
module LEDControl (
    input power,
    input flicker,
    input [7:0] swt,
    input [7:0] leave,
    output reg [15:0] led = 0
);

    integer i;
    always @(*) begin
        for (i = 0; i < 8; i = i+1) begin
            led[i << 1] <= 0;
            // 驶离车位对应的LED灯亮暗由闪烁使能控制
            if (!power || (leave[i] && flicker))  led[(i << 1)+1] <= 0;
            else    led[(i << 1)+1] <= swt[i];
        end
    end

endmodule