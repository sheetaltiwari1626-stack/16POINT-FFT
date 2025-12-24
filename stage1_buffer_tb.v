module stage1_buffer_tb;
    parameter WIDTH = 16;
    integer i;

    reg signed [WIDTH-1:0] xr_in0, xr_in1, xr_in2, xr_in3;
    reg signed [WIDTH-1:0] xr_in4, xr_in5, xr_in6, xr_in7;
    reg signed [WIDTH-1:0] xr_in8, xr_in9, xr_in10, xr_in11;
    reg signed [WIDTH-1:0] xr_in12, xr_in13, xr_in14, xr_in15;

    reg signed [WIDTH-1:0] xi_in0, xi_in1, xi_in2, xi_in3;
    reg signed [WIDTH-1:0] xi_in4, xi_in5, xi_in6, xi_in7;
    reg signed [WIDTH-1:0] xi_in8, xi_in9, xi_in10, xi_in11;
    reg signed [WIDTH-1:0] xi_in12, xi_in13, xi_in14, xi_in15;

    wire signed [WIDTH-1:0] yr_stage1_0, yr_stage1_1, yr_stage1_2, yr_stage1_3;
    wire signed [WIDTH-1:0] yr_stage1_4, yr_stage1_5, yr_stage1_6, yr_stage1_7;
    wire signed [WIDTH-1:0] yr_stage1_8, yr_stage1_9, yr_stage1_10, yr_stage1_11;
    wire signed [WIDTH-1:0] yr_stage1_12, yr_stage1_13, yr_stage1_14, yr_stage1_15;

    wire signed [WIDTH-1:0] yi_stage1_0, yi_stage1_1, yi_stage1_2, yi_stage1_3;
    wire signed [WIDTH-1:0] yi_stage1_4, yi_stage1_5, yi_stage1_6, yi_stage1_7;
    wire signed [WIDTH-1:0] yi_stage1_8, yi_stage1_9, yi_stage1_10, yi_stage1_11;
    wire signed [WIDTH-1:0] yi_stage1_12, yi_stage1_13, yi_stage1_14, yi_stage1_15;

    wire signed [WIDTH-1:0] yr_buf_0, yr_buf_1, yr_buf_2, yr_buf_3;
    wire signed [WIDTH-1:0] yr_buf_4, yr_buf_5, yr_buf_6, yr_buf_7;
    wire signed [WIDTH-1:0] yr_buf_8, yr_buf_9, yr_buf_10, yr_buf_11;
    wire signed [WIDTH-1:0] yr_buf_12, yr_buf_13, yr_buf_14, yr_buf_15;

    wire signed [WIDTH-1:0] yi_buf_0, yi_buf_1, yi_buf_2, yi_buf_3;
    wire signed [WIDTH-1:0] yi_buf_4, yi_buf_5, yi_buf_6, yi_buf_7;
    wire signed [WIDTH-1:0] yi_buf_8, yi_buf_9, yi_buf_10, yi_buf_11;
    wire signed [WIDTH-1:0] yi_buf_12, yi_buf_13, yi_buf_14, yi_buf_15;

    stage1_butterfly_all #(WIDTH) stage1_bf (
        .xr_in0(xr_in0), .xr_in1(xr_in1), .xr_in2(xr_in2), .xr_in3(xr_in3),
        .xr_in4(xr_in4), .xr_in5(xr_in5), .xr_in6(xr_in6), .xr_in7(xr_in7),
        .xr_in8(xr_in8), .xr_in9(xr_in9), .xr_in10(xr_in10), .xr_in11(xr_in11),
        .xr_in12(xr_in12), .xr_in13(xr_in13), .xr_in14(xr_in14), .xr_in15(xr_in15),

        .xi_in0(xi_in0), .xi_in1(xi_in1), .xi_in2(xi_in2), .xi_in3(xi_in3),
        .xi_in4(xi_in4), .xi_in5(xi_in5), .xi_in6(xi_in6), .xi_in7(xi_in7),
        .xi_in8(xi_in8), .xi_in9(xi_in9), .xi_in10(xi_in10), .xi_in11(xi_in11),
        .xi_in12(xi_in12), .xi_in13(xi_in13), .xi_in14(xi_in14), .xi_in15(xi_in15),

        .yr_out0(yr_stage1_0), .yr_out1(yr_stage1_1), .yr_out2(yr_stage1_2), .yr_out3(yr_stage1_3),
        .yr_out4(yr_stage1_4), .yr_out5(yr_stage1_5), .yr_out6(yr_stage1_6), .yr_out7(yr_stage1_7),
        .yr_out8(yr_stage1_8), .yr_out9(yr_stage1_9), .yr_out10(yr_stage1_10), .yr_out11(yr_stage1_11),
        .yr_out12(yr_stage1_12), .yr_out13(yr_stage1_13), .yr_out14(yr_stage1_14), .yr_out15(yr_stage1_15),

        .yi_out0(yi_stage1_0), .yi_out1(yi_stage1_1), .yi_out2(yi_stage1_2), .yi_out3(yi_stage1_3),
        .yi_out4(yi_stage1_4), .yi_out5(yi_stage1_5), .yi_out6(yi_stage1_6), .yi_out7(yi_stage1_7),
        .yi_out8(yi_stage1_8), .yi_out9(yi_stage1_9), .yi_out10(yi_stage1_10), .yi_out11(yi_stage1_11),
        .yi_out12(yi_stage1_12), .yi_out13(yi_stage1_13), .yi_out14(yi_stage1_14), .yi_out15(yi_stage1_15)
    );

    stage1_buffer #(WIDTH) buf_inst (
        .yr_in0(yr_stage1_0), .yr_in1(yr_stage1_1), .yr_in2(yr_stage1_2), .yr_in3(yr_stage1_3),
        .yr_in4(yr_stage1_4), .yr_in5(yr_stage1_5), .yr_in6(yr_stage1_6), .yr_in7(yr_stage1_7),
        .yr_in8(yr_stage1_8), .yr_in9(yr_stage1_9), .yr_in10(yr_stage1_10), .yr_in11(yr_stage1_11),
        .yr_in12(yr_stage1_12), .yr_in13(yr_stage1_13), .yr_in14(yr_stage1_14), .yr_in15(yr_stage1_15),

        .yi_in0(yi_stage1_0), .yi_in1(yi_stage1_1), .yi_in2(yi_stage1_2), .yi_in3(yi_stage1_3),
        .yi_in4(yi_stage1_4), .yi_in5(yi_stage1_5), .yi_in6(yi_stage1_6), .yi_in7(yi_stage1_7),
        .yi_in8(yi_stage1_8), .yi_in9(yi_stage1_9), .yi_in10(yi_stage1_10), .yi_in11(yi_stage1_11),
        .yi_in12(yi_stage1_12), .yi_in13(yi_stage1_13), .yi_in14(yi_stage1_14), .yi_in15(yi_stage1_15),

        .yr_out0(yr_buf_0), .yr_out1(yr_buf_1), .yr_out2(yr_buf_2), .yr_out3(yr_buf_3),
        .yr_out4(yr_buf_4), .yr_out5(yr_buf_5), .yr_out6(yr_buf_6), .yr_out7(yr_buf_7),
        .yr_out8(yr_buf_8), .yr_out9(yr_buf_9), .yr_out10(yr_buf_10), .yr_out11(yr_buf_11),
        .yr_out12(yr_buf_12), .yr_out13(yr_buf_13), .yr_out14(yr_buf_14), .yr_out15(yr_buf_15),

        .yi_out0(yi_buf_0), .yi_out1(yi_buf_1), .yi_out2(yi_buf_2), .yi_out3(yi_buf_3),
        .yi_out4(yi_buf_4), .yi_out5(yi_buf_5), .yi_out6(yi_buf_6), .yi_out7(yi_buf_7),
        .yi_out8(yi_buf_8), .yi_out9(yi_buf_9), .yi_out10(yi_buf_10), .yi_out11(yi_buf_11),
        .yi_out12(yi_buf_12), .yi_out13(yi_buf_13), .yi_out14(yi_buf_14), .yi_out15(yi_buf_15)
    );
    initial begin
        xr_in0=0; xr_in1=1; xr_in2=2; xr_in3=3;
        xr_in4=4; xr_in5=5; xr_in6=6; xr_in7=7;
        xr_in8=8; xr_in9=9; xr_in10=10; xr_in11=11;
        xr_in12=12; xr_in13=13; xr_in14=14; xr_in15=15;
        xi_in0=0; xi_in1=0; xi_in2=0; xi_in3=0;
        xi_in4=0; xi_in5=0; xi_in6=0; xi_in7=0;
        xi_in8=0; xi_in9=0; xi_in10=0; xi_in11=0;
        xi_in12=0; xi_in13=0; xi_in14=0; xi_in15=0;
        #5;
        $display("\n--- Stage1 Buffer Output ---");
        $display("yr_buf_0=%d yi_buf_0=%d", yr_buf_0, yi_buf_0);
        $display("yr_buf_1=%d yi_buf_1=%d", yr_buf_1, yi_buf_1);
        $display("... and so on ...");
        $finish;
    end
initial begin
    $shm_open("wave.shm");
    $shm_probe("ACTMF");
    #2000;
    $finish;
end
endmodule


