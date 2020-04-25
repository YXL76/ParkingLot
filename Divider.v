/**
  * @desc 分频模块 - 使用计数器，在一个计数周期里输出信号发生两次翻转
  * @input wire clk - 系统时钟，f = 50MHz
  * @ouput reg clk_out - 新时钟，f = 50000000 / (kPeriod * 2) Hz
*/
module Divider (
    input clk,
    output reg clk_out = 1'b0
);

    reg [25:0] cnt = 26'b0;

    parameter kPeriod = 25000000;

    always @(posedge clk) begin
        if(cnt == kPeriod-1) begin
            cnt <= 1'b0;
            clk_out <= ~clk_out;
        end
        else    cnt <= cnt + 1'b1;
    end

endmodule