/**
  * @desc 线性反馈移位寄存器模块 - 生成伪随机数
  * @input wire rst - 系统复位
  * @input wire clk - 系统时钟
  * @input wire power - 系统开关
  * @ouput reg [7:0] random - 伪随机序列
*/
module LFSR (
    input rst,
    input clk,
    input power,
    output reg [7:0] random = 8'b1111_1111
);

    wire feedback = random[7] ^ random[5] ^ random[4] ^ random[3];  // 反馈函数

    always @(posedge clk or negedge rst) begin
        if (!rst)   random <= 8'b1111_1111;     // 种子
        else if (!power)    random <= {random[6:0], feedback};
    end

endmodule