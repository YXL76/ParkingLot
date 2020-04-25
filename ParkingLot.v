/**
  * @desc 主模块
  * @input wire rst - 系统复位
  * @input wire clk - 系统时钟，f = 50MHz
  * @input wire pow - 开关按键
  * @input wire pay - 缴费按键
  * @input wire [7:0] swt - 拨码开关
  * @ouput wire rs - lcd寄存器选择
  * @ouput wire rw - lcd读写选择
  * @ouput wire en - lcd使能
  * @ouput wire buz - 蜂鸣器
  * @ouput wire [7:0] row - 点阵行
  * @ouput wire [7:0] col_r - 点阵列（红色）
  * @ouput wire [7:0] col_g - 点阵列（绿色）
  * @ouput wire [7:0] dis - 数码管位置
  * @ouput wire [7:0] seg - 数码管管脚
  * @ouput wire [7:0] lcd - lcd数据总线
  * @ouput wire [15:0] led - LED灯
*/
module ParkingLot (
    input rst,
    input clk,
    input pow,
    input pay,
    input [7:0] swt,
    output rs,
    output rw,
    output en,
    output buz,
    output [7:0] row,
    output [7:0] col_r,
    output [7:0] col_g,
    output [7:0] dis,
    output [7:0] seg,
    output [7:0] lcd,
    output [15:0] led
);
    
    // 仿真用
    /*wire pow_pulse = pow;
    wire pay_pulse = pay;
    wire [7:0] de_swt = swt;
    wire [7:0] de_swt_bar = ~swt;*/
    
    /**************************    系统初始化部分    **************************/

    // 系统启动部分 按下开关后系统启动，按下复位按键系统关闭复位
    reg power = 0;      // power为1代表系统开启，为0代表系统关闭
    always @(posedge pow_pulse or negedge rst) begin
        if (!rst)   power <= 0;
        else    power <= pow_pulse ? ~power : power;
    end

    // 生成伪随机数
    wire [7:0] random;
    LFSR EightBitRandom(rst, clk, power, random);

    /**************************    系统初始化部分    **************************/

    /****************************    分频部分    ****************************/

    wire scan_clk;          // 扫描时钟
    wire debounce_clk;      // 消抖时钟
    wire flicker_clk;       // 闪烁时钟
    wire time_clk;          // 计时时钟
    // f = 50000000 / 100000 = 500Hz
    Divider#(.kPeriod(50000)) ScanDivider(clk, scan_clk);
    // f = 50000000 / 50000000 = 10Hz
    Divider#(.kPeriod(2500000)) DebounceDivider(clk, debounce_clk);
    // f = 50000000 / 25000000 = 2Hz
    Divider#(.kPeriod(12500000)) FlickerDivider(clk, flicker_clk);
    //Divider#(.kPeriod(2)) FlickerDividerTest(clk, flicker_clk);
    // f = 50000000 / 50000000 = 1Hz
    Divider#(.kPeriod(25000000)) TimeDivider(clk, time_clk);
    // Divider#(.kPeriod(6)) TimeDividerTest(clk, time_clk);

    /****************************    分频部分    ****************************/

    /****************************    消抖部分    ****************************/

    wire pow_pulse;         // 开关按键脉冲
    wire pay_pulse;         // 缴费按键脉冲
    wire [7:0] de_swt;      // 拨码开关状态
    KeyDebounce PowDebounce(debounce_clk, pow, pow_pulse);
    KeyDebounce PayDebounce(debounce_clk, pay, pay_pulse);
    SwitchDebounce SwtDebounce(clk, debounce_clk, swt, de_swt);

    // 拨码开关状态取反同时与random相与
    // random为0的位置对应的车位将无效，只有为1的位置才可以正常操作
    wire [7:0] de_swt_bar = ~de_swt & random;

    /****************************    消抖部分    ****************************/

    /****************************    计时部分    ****************************/

    reg [5:0] time_cnt = 0;     // 系统时间
    always @(posedge time_clk or negedge power) begin
        if (!power)  time_cnt <= 0;
        else    time_cnt <= (time_cnt > 22) ? 1'b0 : time_cnt + 1'b1;
    end

    // time_day代表白天停车的时间，time_night代表夜晚停车时间
    // 0~7对应8个车位，8储存当前驶离车辆的停车时间
    reg [5:0] time_day [8:0];
    reg [4:0] time_night [8:0];

    initial begin
        time_day[0] = 0;    time_night[0] = 0;
        time_day[1] = 0;    time_night[1] = 0;
        time_day[2] = 0;    time_night[2] = 0;
        time_day[3] = 0;    time_night[3] = 0;
        time_day[4] = 0;    time_night[4] = 0;
        time_day[5] = 0;    time_night[5] = 0;
        time_day[6] = 0;    time_night[6] = 0;
        time_day[7] = 0;    time_night[7] = 0;
        time_day[8] = 0;    time_night[8] = 0;
    end

    integer i;
    always @(posedge time_clk or negedge power) begin
        for (i = 0; i < 8; i = i+1) begin
            if (!power) begin time_day[i] <= 0; time_night[i] <= 0; end
            else begin
                if (de_swt[i]) begin
                    if (time_cnt >= 6 && time_cnt <= 22)
                            time_day[i] <= time_day[i] + 1'b1;
                    else    time_night[i] <= time_night[i] + 1'b1;
                end
                else    begin time_day[i] <= 0; time_night[i] <= 0; end
            end
        end
    end

    /****************************    计时部分    ****************************/

    /****************************    缴费部分    ****************************/

    // 多位正边沿检测检测，判断是否有车辆驶离
    reg [7:0] swt_dly = 8'b1111_1111;
    reg [7:0] swt_edge = 0;

    always @(posedge clk) begin
        swt_dly <= power ? de_swt_bar : 8'b1111_1111;
        swt_edge <= power ?  (~swt_dly) & de_swt_bar : 8'b0;
    end

    reg need_pay = 0;       // need_pay为1时系统处于待缴费状态
    reg [7:0] leave = 0;    // leave为1的位置代表该车位处于待缴费状态

    always @(posedge clk) begin
        // 当系统启动并且不处于待缴费状态时，检测车辆驶离
        if (power && !need_pay && |swt_edge) begin
            need_pay <= 1; leave <= swt_edge;
            // 把驶离车辆的停车信息存到time_day[8]和time_night[8]中
            case (swt_edge)
                8'b0000_0001 : begin time_day[8]   <= time_day[0];
                                     time_night[8] <= time_night[0]; end
                8'b0000_0010 : begin time_day[8]   <= time_day[1];
                                     time_night[8] <= time_night[1]; end
                8'b0000_0100 : begin time_day[8]   <= time_day[2];
                                     time_night[8] <= time_night[2]; end
                8'b0000_1000 : begin time_day[8]   <= time_day[3];
                                     time_night[8] <= time_night[3]; end
                8'b0001_0000 : begin time_day[8]   <= time_day[4];
                                     time_night[8] <= time_night[4]; end
                8'b0010_0000 : begin time_day[8]   <= time_day[5];
                                     time_night[8] <= time_night[5]; end
                8'b0100_0000 : begin time_day[8]   <= time_day[6];
                                     time_night[8] <= time_night[6]; end
                8'b1000_0000 : begin time_day[8]   <= time_day[7];
                                     time_night[8] <= time_night[7]; end
            endcase
        end
        // 当系统未启动或者按下缴费按键时，系统结束待缴费状态
        if (!power || pay_pulse)    begin need_pay <= 0; leave <= 0; end
    end

    // 1位移位寄存器，以2Hz的速度左移
    // 在need_pay上升后，往移位寄存器加入一个1，其余时刻加0
    // 从而产生一个的延时器
    reg need_pay_Q1 = 0;
    reg [1:0] delay = 0;

    always @(posedge flicker_clk) begin
        need_pay_Q1 <= need_pay;
        if (need_pay_Q1 & ~need_pay)  delay <= {delay[0:0], 1'b1};
        else    delay <= {delay[0:0], 1'b0};
    end

    /****************************    缴费部分    ****************************/

    /****************************    视图部分    ****************************/

    LEDControl CarPort(power, (!flicker_clk || !need_pay), de_swt_bar, leave, led);

    // 因为数码管的个数和点阵行列数都是8，所以计数的范围为0～7
    reg [2:0] scan_cnt = 0;
    always @(posedge scan_clk) begin
        scan_cnt <= (scan_cnt > 6) ? 1'b0 : scan_cnt + 1'b1;
    end

    // 当前可用的车位数可直接由拨码开关的状态相加得到
    // 同时要考虑到待缴费状态，所以再减去 need_pay
    wire [3:0] car = de_swt_bar[0] + de_swt_bar[1] + de_swt_bar[2] +
                     de_swt_bar[3] + de_swt_bar[4] + de_swt_bar[5] +
                     de_swt_bar[6] + de_swt_bar[7] - need_pay;

    DotMatrix CarDotMatrix(power, (flicker_clk || !need_pay),
                           car, scan_cnt, row, col_r, col_g);

    Segment TimeCounter(power, |delay, need_pay | need_pay_Q1, flicker_clk,
                        time_cnt, scan_cnt, time_day[8], time_night[8], dis, seg);

    // 蜂鸣器在延时器工作时发生，频率与scan_clk(500Hz)相同
    assign buz = (|delay && power) ? scan_clk : 1'b0;

    LCD LCDDisplay(rst, clk, scan_clk, power, car, time_cnt, rw, en, rs, lcd);

    /****************************    视图部分    ****************************/

endmodule