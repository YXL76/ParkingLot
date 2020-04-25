/**
  * @desc LCD显示模块 - 控制LCD显示的内容
  * @input wire rst - 系统复位
  * @input wire clk - 系统时钟，f = 50MHz
  * @input wire scan_clk - 慢速时钟，f = 500Hz
  * @input wire power - 系统开关
  * @input wire [3:0] car - 可用车位数
  * @input wire [5:0] time_cnt - 系统时间
  * @ouput wire RW - 读写选择
  * @ouput wire EN - 使能
  * @ouput reg RS - 寄存器选择
  * @ouput reg [7 : 0] data_bus - 数据总线
*/
module LCD (
    input rst,
    input clk,
    input scan_clk,
    input power,
    input [3:0] car,
    input [5:0] time_cnt,
    output RW,
    output EN,
    output reg RS = 0,
    output reg [7:0] data_bus = 0
);
    
    // 译码部分
    // 根据可用车位数和系统时间更改显示的内容
    reg [127:0] row_1 = "                ";
    reg [127:0] row_2 = "                ";

    always @(posedge clk or negedge power) begin
        if (!power) row_1 = "                ";
        else case (time_cnt)
            0 :     row_1 <= " Time: 00 Night ";
            1 :     row_1 <= " Time: 01 Night ";
            2 :     row_1 <= " Time: 02 Night ";
            3 :     row_1 <= " Time: 03 Night ";
            4 :     row_1 <= " Time: 04 Night ";
            5 :     row_1 <= " Time: 05 Night ";
            6 :     row_1 <= " Time: 06 Day   ";
            7 :     row_1 <= " Time: 07 Day   ";
            8 :     row_1 <= " Time: 08 Day   ";
            9 :     row_1 <= " Time: 09 Day   ";
            10 :    row_1 <= " Time: 10 Day   ";
            11 :    row_1 <= " Time: 11 Day   ";
            12 :    row_1 <= " Time: 12 Day   ";
            13 :    row_1 <= " Time: 13 Day   ";
            14 :    row_1 <= " Time: 14 Day   ";
            15 :    row_1 <= " Time: 15 Day   ";
            16 :    row_1 <= " Time: 16 Day   ";
            17 :    row_1 <= " Time: 17 Day   ";
            18 :    row_1 <= " Time: 18 Day   ";
            19 :    row_1 <= " Time: 19 Day   ";
            20 :    row_1 <= " Time: 20 Day   ";
            21 :    row_1 <= " Time: 21 Day   ";
            22 :    row_1 <= " Time: 22 Day   ";
            23 :    row_1 <= " Time: 23 Night ";
        endcase
    end

    always @(posedge clk or negedge power) begin
        if (!power) row_2 <= "                ";
        else case (car)
            0 :     row_2 <= " Space: 0       ";
            1 :     row_2 <= " Space: 1       ";
            2 :     row_2 <= " Space: 2       ";
            3 :     row_2 <= " Space: 3       ";
            4 :     row_2 <= " Space: 4       ";
            5 :     row_2 <= " Space: 5       ";
            6 :     row_2 <= " Space: 6       ";
            7 :     row_2 <= " Space: 7       ";
            8 :     row_2 <= " Space: 8       ";
        endcase
    end
    
    reg Q = 0;
    always @(posedge clk) begin
        Q <= scan_clk;
    end

    assign RW = 1'b0;   // 始终只进行写入
    assign EN = scan_clk;
    wire write_flag = ~Q & scan_clk;

    // 40个状态
    localparam        IDLE = 8'h00;
    // 初始化
    localparam    DISP_SET = 8'h01;    // 清屏
    localparam    DISP_OFF = 8'h03;    // 关闭显示
    localparam     CLR_SCR = 8'h02;    // 光标归位
    localparam CURSOR_SET1 = 8'h06;    // 设置光标
    localparam CURSOR_SET2 = 8'h07;    // 开启显示
    // 显示第一行
    localparam   ROW1_ADDR = 8'h05;
    localparam      ROW1_0 = 8'h04;
    localparam      ROW1_1 = 8'h0C;
    localparam      ROW1_2 = 8'h0D;
    localparam      ROW1_3 = 8'h0F;
    localparam      ROW1_4 = 8'h0E;
    localparam      ROW1_5 = 8'h0A;
    localparam      ROW1_6 = 8'h0B;
    localparam      ROW1_7 = 8'h09;
    localparam      ROW1_8 = 8'h08;
    localparam      ROW1_9 = 8'h18;
    localparam      ROW1_A = 8'h19;
    localparam      ROW1_B = 8'h1B;
    localparam      ROW1_C = 8'h1A;
    localparam      ROW1_D = 8'h1E;
    localparam      ROW1_E = 8'h1F;
    localparam      ROW1_F = 8'h1D;
    // 显示第二行
    localparam   ROW2_ADDR = 8'h1C;
    localparam      ROW2_0 = 8'h14;
    localparam      ROW2_1 = 8'h15;
    localparam      ROW2_2 = 8'h17;
    localparam      ROW2_3 = 8'h16;
    localparam      ROW2_4 = 8'h12;
    localparam      ROW2_5 = 8'h13;
    localparam      ROW2_6 = 8'h11;
    localparam      ROW2_7 = 8'h10;
    localparam      ROW2_8 = 8'h30;
    localparam      ROW2_9 = 8'h31;
    localparam      ROW2_A = 8'h33;
    localparam      ROW2_B = 8'h32;
    localparam      ROW2_C = 8'h36;
    localparam      ROW2_D = 8'h37;
    localparam      ROW2_E = 8'h35;
    localparam      ROW2_F = 8'h34;

    reg [7:0] current_state = IDLE;
    reg [7:0] next_state = IDLE;
    always @(posedge clk or negedge rst) begin
        if (!rst)  current_state <= IDLE;
        else if (write_flag)  current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            // 初始化
            IDLE :        next_state = DISP_SET;
            DISP_SET :    next_state = DISP_OFF;
            DISP_OFF :    next_state = CLR_SCR;
            CLR_SCR :     next_state = CURSOR_SET1;
            CURSOR_SET1 : next_state = CURSOR_SET2;
            CURSOR_SET2 : next_state = ROW1_ADDR;
            // 显示第一行
            ROW1_ADDR :   next_state = ROW1_0;
            ROW1_0 :      next_state = ROW1_1;
            ROW1_1 :      next_state = ROW1_2;
            ROW1_2 :      next_state = ROW1_3;
            ROW1_3 :      next_state = ROW1_4;
            ROW1_4 :      next_state = ROW1_5;
            ROW1_5 :      next_state = ROW1_6;
            ROW1_6 :      next_state = ROW1_7;
            ROW1_7 :      next_state = ROW1_8;
            ROW1_8 :      next_state = ROW1_9;
            ROW1_9 :      next_state = ROW1_A;
            ROW1_A :      next_state = ROW1_B;
            ROW1_B :      next_state = ROW1_C;
            ROW1_C :      next_state = ROW1_D;
            ROW1_D :      next_state = ROW1_E;
            ROW1_E :      next_state = ROW1_F;
            ROW1_F :      next_state = ROW2_ADDR;
            // 显示第二行
            ROW2_ADDR :   next_state = ROW2_0;
            ROW2_0 :      next_state = ROW2_1;
            ROW2_1 :      next_state = ROW2_2;
            ROW2_2 :      next_state = ROW2_3;
            ROW2_3 :      next_state = ROW2_4;
            ROW2_4 :      next_state = ROW2_5;
            ROW2_5 :      next_state = ROW2_6;
            ROW2_6 :      next_state = ROW2_7;
            ROW2_7 :      next_state = ROW2_8;
            ROW2_8 :      next_state = ROW2_9;
            ROW2_9 :      next_state = ROW2_A;
            ROW2_A :      next_state = ROW2_B;
            ROW2_B :      next_state = ROW2_C;
            ROW2_C :      next_state = ROW2_D;
            ROW2_D :      next_state = ROW2_E;
            ROW2_E :      next_state = ROW2_F;
            ROW2_F :      next_state = ROW1_ADDR;
            default :     next_state = IDLE;
        endcase
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) RS <= 1'b0;
        else if (write_flag) begin
            if (next_state == IDLE        || next_state == DISP_SET    ||
                next_state == DISP_OFF    || next_state == CLR_SCR     ||
                next_state == CURSOR_SET1 || next_state == CURSOR_SET2 ||
                next_state == ROW1_ADDR   || next_state == ROW2_ADDR)
                    RS <= 1'b0;     //写入指令
            else    RS <= 1'b1;     //写入数据
        end
    end

    always @(posedge clk or negedge rst) begin
        if (!rst)             data_bus <= 8'hxx;
        else if (write_flag)
            case (next_state)
                IDLE :        data_bus <= 8'hxx;
                // 初始化
                DISP_SET :    data_bus <= 8'h38;
                DISP_OFF :    data_bus <= 8'h08;
                CLR_SCR :     data_bus <= 8'h01;
                CURSOR_SET1 : data_bus <= 8'h06;
                CURSOR_SET2 : data_bus <= 8'h0c;
                // 显示第一行
                ROW1_ADDR :   data_bus <= 8'h80;
                ROW1_0 :      data_bus <= row_1[127:120];
                ROW1_1 :      data_bus <= row_1[119:112];
                ROW1_2 :      data_bus <= row_1[111:104];
                ROW1_3 :      data_bus <= row_1[103:96 ];
                ROW1_4 :      data_bus <= row_1[95 :88 ];
                ROW1_5 :      data_bus <= row_1[87 :80 ];
                ROW1_6 :      data_bus <= row_1[79 :72 ];
                ROW1_7 :      data_bus <= row_1[71 :64 ];
                ROW1_8 :      data_bus <= row_1[63 :56 ];
                ROW1_9 :      data_bus <= row_1[55 :48 ];
                ROW1_A :      data_bus <= row_1[47 :40 ];
                ROW1_B :      data_bus <= row_1[39 :32 ];
                ROW1_C :      data_bus <= row_1[31 :24 ];
                ROW1_D :      data_bus <= row_1[23 :16 ];
                ROW1_E :      data_bus <= row_1[15 :8  ];
                ROW1_F :      data_bus <= row_1[7  :0  ];
                // 显示第二行
                ROW2_ADDR :   data_bus <= 8'hC0;
                ROW2_0 :      data_bus <= row_2[127:120];
                ROW2_1 :      data_bus <= row_2[119:112];
                ROW2_2 :      data_bus <= row_2[111:104];
                ROW2_3 :      data_bus <= row_2[103:96 ];
                ROW2_4 :      data_bus <= row_2[95 :88 ];
                ROW2_5 :      data_bus <= row_2[87 :80 ];
                ROW2_6 :      data_bus <= row_2[79 :72 ];
                ROW2_7 :      data_bus <= row_2[71 :64 ];
                ROW2_8 :      data_bus <= row_2[63 :56 ];
                ROW2_9 :      data_bus <= row_2[55 :48 ];
                ROW2_A :      data_bus <= row_2[47 :40 ];
                ROW2_B :      data_bus <= row_2[39 :32 ];
                ROW2_C :      data_bus <= row_2[31 :24 ];
                ROW2_D :      data_bus <= row_2[23 :16 ];
                ROW2_E :      data_bus <= row_2[15 :8  ];
                ROW2_F :      data_bus <= row_2[7  :0  ];
            endcase
    end

endmodule