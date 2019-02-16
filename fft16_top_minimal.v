module fft16_top_minimal
#(
    parameter WIDTH = 16,
    parameter N = 16
)
(
    input clk,
    input rst,
    input load,
    input [3:0] addr_in,
    input signed [WIDTH-1:0] xr_in,
    output [N*WIDTH-1:0] st1_yr,
    output [N*WIDTH-1:0] st1_yi
);

    // Input buffer outputs (connect only index 0 for test, others zero)
    wire signed [WIDTH-1:0] xr_out0, xi_out0;
    input_buffer #(.N(N), .WIDTH(WIDTH)) inbuf (
        .clk(clk),
        .rst(rst),
        .load(load),
        .addr_in(addr_in),
        .xr_in(xr_in),
        .xr_out0(xr_out0),
        .xi_out0(xi_out0)
    );

    // Prepare all stage1 butterfly inputs (test: only xr_out0, others zero)
    wire signed [WIDTH-1:0] xr_buf [0:N-1];
    wire signed [WIDTH-1:0] xi_buf [0:N-1];
    assign xr_buf[0] = xr_out0;
    assign xi_buf[0] = xi_out0;
    genvar i;
    generate
        for (i = 1; i < N; i = i + 1) begin : zeropad
            assign xr_buf[i] = 0;
            assign xi_buf[i] = 0;
        end
    endgenerate

    // Stage1 butterfly internal outputs
    wire signed [WIDTH-1:0] st1_yr_array [0:N-1];
    wire signed [WIDTH-1:0] st1_yi_array [0:N-1];

    stage1_butterfly_all #(.WIDTH(WIDTH)) s1but (
        .xr_in0(xr_buf[0]),  .xi_in0(xi_buf[0]),
        .xr_in1(xr_buf[1]),  .xi_in1(xi_buf[1]),
        .xr_in2(xr_buf[2]),  .xi_in2(xi_buf[2]),
        .xr_in3(xr_buf[3]),  .xi_in3(xi_buf[3]),
        .xr_in4(xr_buf[4]),  .xi_in4(xi_buf[4]),
        .xr_in5(xr_buf[5]),  .xi_in5(xi_buf[5]),
        .xr_in6(xr_buf[6]),  .xi_in6(xi_buf[6]),
        .xr_in7(xr_buf[7]),  .xi_in7(xi_buf[7]),
        .xr_in8(xr_buf[8]),  .xi_in8(xi_buf[8]),
        .xr_in9(xr_buf[9]),  .xi_in9(xi_buf[9]),
        .xr_in10(xr_buf[10]),.xi_in10(xi_buf[10]),
        .xr_in11(xr_buf[11]),.xi_in11(xi_buf[11]),
        .xr_in12(xr_buf[12]),.xi_in12(xi_buf[12]),
        .xr_in13(xr_buf[13]),.xi_in13(xi_buf[13]),
        .xr_in14(xr_buf[14]),.xi_in14(xi_buf[14]),
        .xr_in15(xr_buf[15]),.xi_in15(xi_buf[15]),
        .yr_out0(st1_yr_array[0]),  .yi_out0(st1_yi_array[0]),
        .yr_out1(st1_yr_array[1]),  .yi_out1(st1_yi_array[1]),
        .yr_out2(st1_yr_array[2]),  .yi_out2(st1_yi_array[2]),
        .yr_out3(st1_yr_array[3]),  .yi_out3(st1_yi_array[3]),
        .yr_out4(st1_yr_array[4]),  .yi_out4(st1_yi_array[4]),
        .yr_out5(st1_yr_array[5]),  .yi_out5(st1_yi_array[5]),
        .yr_out6(st1_yr_array[6]),  .yi_out6(st1_yi_array[6]),
        .yr_out7(st1_yr_array[7]),  .yi_out7(st1_yi_array[7]),
        .yr_out8(st1_yr_array[8]),  .yi_out8(st1_yi_array[8]),
        .yr_out9(st1_yr_array[9]),  .yi_out9(st1_yi_array[9]),
        .yr_out10(st1_yr_array[10]),.yi_out10(st1_yi_array[10]),
        .yr_out11(st1_yr_array[11]),.yi_out11(st1_yi_array[11]),
        .yr_out12(st1_yr_array[12]),.yi_out12(st1_yi_array[12]),
        .yr_out13(st1_yr_array[13]),.yi_out13(st1_yi_array[13]),
        .yr_out14(st1_yr_array[14]),.yi_out14(st1_yi_array[14]),
        .yr_out15(st1_yr_array[15]),.yi_out15(st1_yi_array[15])
    );

    // Flatten outputs for testbench
    generate
        for (i = 0; i < N; i = i + 1) begin : out_flatten
            assign st1_yr[(i+1)*WIDTH-1:i*WIDTH] = st1_yr_array[i];
            assign st1_yi[(i+1)*WIDTH-1:i*WIDTH] = st1_yi_array[i];
        end
    endgenerate

endmodule

