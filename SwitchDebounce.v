/**
  * @desc 拨码开关消抖模块 - 与按键消抖模块类似，不过把脉冲信号变为了持续信号
  * @input wire debounce_clk - 消抖时钟
  * @input wire [7:0] swt - 拨码开关
  * @ouput reg [7:0] de_swt - 消抖后的拨码开关状态
*/
module SwitchDebounce (
    input clk,
    input debounce_clk,
    input [7:0] swt,
    output reg [7:0] de_swt = 0
);

    reg [7:0] Q1 = 0;
    reg [7:0] Q2 = 0;

    // D触发器
    always @(posedge clk) begin
        Q1 <= swt;
        Q2 <= Q1;
        if (de_swt != Q2 && debounce_clk)    de_swt <= Q2;
    end

endmodule