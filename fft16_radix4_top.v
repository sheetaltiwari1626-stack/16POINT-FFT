module fft16_radix4_top #(
    parameter N = 16,
    parameter WIDTH = 16,
    parameter OUTW = 48
)(
    input  wire clk,
    input  wire rst,
    input  wire load,
    input  wire [3:0] addr_in,
    input  wire signed [WIDTH-1:0] xr_in,

    output wire signed [WIDTH-1:0] xr_out0,
    output wire signed [WIDTH-1:0] xi_out0,
    output wire signed [N*OUTW-1:0] yr_stage2_flat,
    output wire signed [N*OUTW-1:0] yi_stage2_flat
);

    // Internal arrays
    wire signed [WIDTH-1:0] xr_in_arr [0:N-1];
    wire signed [WIDTH-1:0] xi_in_arr [0:N-1];
    wire signed [WIDTH-1:0] yr_stage1 [0:N-1];
    wire signed [WIDTH-1:0] yi_stage1 [0:N-1];
    wire signed [WIDTH-1:0] yr_buf    [0:N-1];
    wire signed [WIDTH-1:0] yi_buf    [0:N-1];

    // Flattened buses
    wire signed [N*WIDTH-1:0] xr_flat;
    wire signed [N*WIDTH-1:0] xi_flat;
    wire signed [N*WIDTH-1:0] yr_buf_flat;
    wire signed [N*WIDTH-1:0] yi_buf_flat;

    // ============================================================
    // 1. Input Buffer
    // ============================================================
    input_buffer #(
        .N(N),
        .WIDTH(WIDTH)
    ) inbuf_inst (
        .clk(clk),
        .rst(rst),
        .load(load),
        .addr_in(addr_in),
        .xr_in(xr_in),
        .xr_out0(xr_out0),
        .xi_out0(xi_out0),
        .xr_flat(xr_flat),
        .xi_flat(xi_flat)
    );

    // Unpack flattened inputs
    genvar k;
    generate
        for (k = 0; k < N; k = k + 1) begin : UNPACK_IN
            assign xr_in_arr[k] = xr_flat[k*WIDTH +: WIDTH];
            assign xi_in_arr[k] = xi_flat[k*WIDTH +: WIDTH];
        end
    endgenerate

    // ============================================================
    // 2. Stage 1 Butterfly
    // ============================================================
    stage1_butterfly_all #(.WIDTH(WIDTH)) stg1_bf (
        .xr_in0(xr_in_arr[0]),   .xr_in1(xr_in_arr[1]),
        .xr_in2(xr_in_arr[2]),   .xr_in3(xr_in_arr[3]),
        .xr_in4(xr_in_arr[4]),   .xr_in5(xr_in_arr[5]),
        .xr_in6(xr_in_arr[6]),   .xr_in7(xr_in_arr[7]),
        .xr_in8(xr_in_arr[8]),   .xr_in9(xr_in_arr[9]),
        .xr_in10(xr_in_arr[10]), .xr_in11(xr_in_arr[11]),
        .xr_in12(xr_in_arr[12]), .xr_in13(xr_in_arr[13]),
        .xr_in14(xr_in_arr[14]), .xr_in15(xr_in_arr[15]),

        .xi_in0(xi_in_arr[0]),   .xi_in1(xi_in_arr[1]),
        .xi_in2(xi_in_arr[2]),   .xi_in3(xi_in_arr[3]),
        .xi_in4(xi_in_arr[4]),   .xi_in5(xi_in_arr[5]),
        .xi_in6(xi_in_arr[6]),   .xi_in7(xi_in_arr[7]),
        .xi_in8(xi_in_arr[8]),   .xi_in9(xi_in_arr[9]),
        .xi_in10(xi_in_arr[10]), .xi_in11(xi_in_arr[11]),
        .xi_in12(xi_in_arr[12]), .xi_in13(xi_in_arr[13]),
        .xi_in14(xi_in_arr[14]), .xi_in15(xi_in_arr[15]),

        .yr_out0(yr_stage1[0]),  .yr_out1(yr_stage1[1]),
        .yr_out2(yr_stage1[2]),  .yr_out3(yr_stage1[3]),
        .yr_out4(yr_stage1[4]),  .yr_out5(yr_stage1[5]),
        .yr_out6(yr_stage1[6]),  .yr_out7(yr_stage1[7]),
        .yr_out8(yr_stage1[8]),  .yr_out9(yr_stage1[9]),
        .yr_out10(yr_stage1[10]),.yr_out11(yr_stage1[11]),
        .yr_out12(yr_stage1[12]),.yr_out13(yr_stage1[13]),
        .yr_out14(yr_stage1[14]),.yr_out15(yr_stage1[15]),

        .yi_out0(yi_stage1[0]),  .yi_out1(yi_stage1[1]),
        .yi_out2(yi_stage1[2]),  .yi_out3(yi_stage1[3]),
        .yi_out4(yi_stage1[4]),  .yi_out5(yi_stage1[5]),
        .yi_out6(yi_stage1[6]),  .yi_out7(yi_stage1[7]),
        .yi_out8(yi_stage1[8]),  .yi_out9(yi_stage1[9]),
        .yi_out10(yi_stage1[10]),.yi_out11(yi_stage1[11]),
        .yi_out12(yi_stage1[12]),.yi_out13(yi_stage1[13]),
        .yi_out14(yi_stage1[14]),.yi_out15(yi_stage1[15])
    );

    // ============================================================
    // 3. Stage 1 Buffer
    // ============================================================
    stage1_buffer #(.WIDTH(WIDTH)) stg1_buf (
        .yr_in0(yr_stage1[0]),   .yr_in1(yr_stage1[1]),
        .yr_in2(yr_stage1[2]),   .yr_in3(yr_stage1[3]),
        .yr_in4(yr_stage1[4]),   .yr_in5(yr_stage1[5]),
        .yr_in6(yr_stage1[6]),   .yr_in7(yr_stage1[7]),
        .yr_in8(yr_stage1[8]),   .yr_in9(yr_stage1[9]),
        .yr_in10(yr_stage1[10]), .yr_in11(yr_stage1[11]),
        .yr_in12(yr_stage1[12]), .yr_in13(yr_stage1[13]),
        .yr_in14(yr_stage1[14]), .yr_in15(yr_stage1[15]),

        .yi_in0(yi_stage1[0]),   .yi_in1(yi_stage1[1]),
        .yi_in2(yi_stage1[2]),   .yi_in3(yi_stage1[3]),
        .yi_in4(yi_stage1[4]),   .yi_in5(yi_stage1[5]),
        .yi_in6(yi_stage1[6]),   .yi_in7(yi_stage1[7]),
        .yi_in8(yi_stage1[8]),   .yi_in9(yi_stage1[9]),
        .yi_in10(yi_stage1[10]), .yi_in11(yi_stage1[11]),
        .yi_in12(yi_stage1[12]), .yi_in13(yi_stage1[13]),
        .yi_in14(yi_stage1[14]), .yi_in15(yi_stage1[15]),

        .yr_out0(yr_buf[0]),     .yr_out1(yr_buf[1]),
        .yr_out2(yr_buf[2]),     .yr_out3(yr_buf[3]),
        .yr_out4(yr_buf[4]),     .yr_out5(yr_buf[5]),
        .yr_out6(yr_buf[6]),     .yr_out7(yr_buf[7]),
        .yr_out8(yr_buf[8]),     .yr_out9(yr_buf[9]),
        .yr_out10(yr_buf[10]),   .yr_out11(yr_buf[11]),
        .yr_out12(yr_buf[12]),   .yr_out13(yr_buf[13]),
        .yr_out14(yr_buf[14]),   .yr_out15(yr_buf[15]),

        .yi_out0(yi_buf[0]),     .yi_out1(yi_buf[1]),
        .yi_out2(yi_buf[2]),     .yi_out3(yi_buf[3]),
        .yi_out4(yi_buf[4]),     .yi_out5(yi_buf[5]),
        .yi_out6(yi_buf[6]),     .yi_out7(yi_buf[7]),
        .yi_out8(yi_buf[8]),     .yi_out9(yi_buf[9]),
        .yi_out10(yi_buf[10]),   .yi_out11(yi_buf[11]),
        .yi_out12(yi_buf[12]),   .yi_out13(yi_buf[13]),
        .yi_out14(yi_buf[14]),   .yi_out15(yi_buf[15])
    );

    // Flatten stage1 buffer outputs
    genvar m;
    generate
        for (m = 0; m < N; m = m + 1) begin : FLATTEN_BUF
            assign yr_buf_flat[m*WIDTH +: WIDTH] = yr_buf[m];
            assign yi_buf_flat[m*WIDTH +: WIDTH] = yi_buf[m];
        end
    endgenerate

    // ============================================================
    // 4. Stage 2 Butterfly
    // ============================================================
    stage2_butterfly_rounded #(
        .INW(WIDTH),
        .OUTW(OUTW)
    ) stg2_bf (
        .xr_in_flat(yr_buf_flat),
        .xi_in_flat(yi_buf_flat),
        .yr_out_flat(yr_stage2_flat),
        .yi_out_flat(yi_stage2_flat)
    );

endmodule

