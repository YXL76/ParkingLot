/**
  * @desc 按键消抖模块 - 使用两个D触发器，检测到按键信号在消抖时钟周期发生翻转才产生脉冲
  * @input wire debounce_clk - 消抖时钟
  * @input wire key - 消抖按键
  * @ouput wire key_pulse - 脉冲
*/
module KeyDebounce (
    input debounce_clk,
    input key,
    output key_pulse
);

    reg Q1 = 1'b0;
    reg Q2 = 1'b0;

    // D触发器
    always @ (posedge debounce_clk) begin
        Q1 <= key;
        Q2 <= Q1;
    end

    assign key_pulse = Q1 & ~Q2;

endmodule