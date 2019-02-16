module fft16_top #
(
    parameter WIDTH = 16
)
(
    input  wire                   clk,
    input  wire                   rst,
    input  wire                   load,
    input  wire  [3:0]            addr_in,
    input  wire  signed [WIDTH-1:0] xr_in,

    output wire signed [WIDTH-1:0] yr_out0,  yr_out1,  yr_out2,  yr_out3,
    output wire signed [WIDTH-1:0] yr_out4,  yr_out5,  yr_out6,  yr_out7,
    output wire signed [WIDTH-1:0] yr_out8,  yr_out9,  yr_out10, yr_out11,
    output wire signed [WIDTH-1:0] yr_out12, yr_out13, yr_out14, yr_out15,

    output wire signed [WIDTH-1:0] yi_out0,  yi_out1,  yi_out2,  yi_out3,
    output wire signed [WIDTH-1:0] yi_out4,  yi_out5,  yi_out6,  yi_out7,
    output wire signed [WIDTH-1:0] yi_out8,  yi_out9,  yi_out10, yi_out11,
    output wire signed [WIDTH-1:0] yi_out12, yi_out13, yi_out14, yi_out15
);

    /* ===============================
       Internal wires
    =============================== */

    wire signed [WIDTH-1:0] xr_mem [0:15];
    wire signed [WIDTH-1:0] xi_mem [0:15];

    wire signed [WIDTH-1:0] s1_yr [0:15];
    wire signed [WIDTH-1:0] s1_yi [0:15];

    wire signed [WIDTH-1:0] s2_yr [0:15];
    wire signed [WIDTH-1:0] s2_yi [0:15];

    /* ===============================
       Input Buffer
    =============================== */

    input_buffer #(
        .N(16),
        .WIDTH(WIDTH)
    ) input_buf (
        .clk(clk),
        .rst(rst),
        .load(load),
        .addr_in(addr_in),
        .xr_in(xr_in),
        .xr_out0(),     // optional monitoring
        .xi_out0()
    );

    /* ===============================
       Stage 1 Butterfly
    =============================== */

    stage1_butterfly_all #(
        .WIDTH(WIDTH)
    ) stage1 (
        .xr_in0(xr_mem[0]),  .xr_in1(xr_mem[1]),
        .xr_in2(xr_mem[2]),  .xr_in3(xr_mem[3]),
        .xr_in4(xr_mem[4]),  .xr_in5(xr_mem[5]),
        .xr_in6(xr_mem[6]),  .xr_in7(xr_mem[7]),
        .xr_in8(xr_mem[8]),  .xr_in9(xr_mem[9]),
        .xr_in10(xr_mem[10]),.xr_in11(xr_mem[11]),
        .xr_in12(xr_mem[12]),.xr_in13(xr_mem[13]),
        .xr_in14(xr_mem[14]),.xr_in15(xr_mem[15]),

        .xi_in0(0), .xi_in1(0), .xi_in2(0), .xi_in3(0),
        .xi_in4(0), .xi_in5(0), .xi_in6(0), .xi_in7(0),
        .xi_in8(0), .xi_in9(0), .xi_in10(0), .xi_in11(0),
        .xi_in12(0),.xi_in13(0),.xi_in14(0),.xi_in15(0),

        .yr_out0(s1_yr[0]),   .yr_out1(s1_yr[1]),
        .yr_out2(s1_yr[2]),   .yr_out3(s1_yr[3]),
        .yr_out4(s1_yr[4]),   .yr_out5(s1_yr[5]),
        .yr_out6(s1_yr[6]),   .yr_out7(s1_yr[7]),
        .yr_out8(s1_yr[8]),   .yr_out9(s1_yr[9]),
        .yr_out10(s1_yr[10]), .yr_out11(s1_yr[11]),
        .yr_out12(s1_yr[12]), .yr_out13(s1_yr[13]),
        .yr_out14(s1_yr[14]), .yr_out15(s1_yr[15]),

        .yi_out0(s1_yi[0]),   .yi_out1(s1_yi[1]),
        .yi_out2(s1_yi[2]),   .yi_out3(s1_yi[3]),
        .yi_out4(s1_yi[4]),   .yi_out5(s1_yi[5]),
        .yi_out6(s1_yi[6]),   .yi_out7(s1_yi[7]),
        .yi_out8(s1_yi[8]),   .yi_out9(s1_yi[9]),
        .yi_out10(s1_yi[10]), .yi_out11(s1_yi[11]),
        .yi_out12(s1_yi[12]), .yi_out13(s1_yi[13]),
        .yi_out14(s1_yi[14]), .yi_out15(s1_yi[15])
    );

    /* ===============================
       Stage 2 Butterfly (with Twiddle)
    =============================== */

    stage2_butterfly_rounded #(
        .WIDTH(WIDTH)
    ) stage2 (
        .xr_in_flat({
            s1_yr[15], s1_yr[14], s1_yr[13], s1_yr[12],
            s1_yr[11], s1_yr[10], s1_yr[9],  s1_yr[8],
            s1_yr[7],  s1_yr[6],  s1_yr[5],  s1_yr[4],
            s1_yr[3],  s1_yr[2],  s1_yr[1],  s1_yr[0]
        }),
        .xi_in_flat({
            s1_yi[15], s1_yi[14], s1_yi[13], s1_yi[12],
            s1_yi[11], s1_yi[10], s1_yi[9],  s1_yi[8],
            s1_yi[7],  s1_yi[6],  s1_yi[5],  s1_yi[4],
            s1_yi[3],  s1_yi[2],  s1_yi[1],  s1_yi[0]
        }),
        .yr_out_flat({
            s2_yr[15], s2_yr[14], s2_yr[13], s2_yr[12],
            s2_yr[11], s2_yr[10], s2_yr[9],  s2_yr[8],
            s2_yr[7],  s2_yr[6],  s2_yr[5],  s2_yr[4],
            s2_yr[3],  s2_yr[2],  s2_yr[1],  s2_yr[0]
        }),
        .yi_out_flat({
            s2_yi[15], s2_yi[14], s2_yi[13], s2_yi[12],
            s2_yi[11], s2_yi[10], s2_yi[9],  s2_yi[8],
            s2_yi[7],  s2_yi[6],  s2_yi[5],  s2_yi[4],
            s2_yi[3],  s2_yi[2],  s2_yi[1],  s2_yi[0]
        })
    );

    /* ===============================
       Final Outputs
    =============================== */

    assign { yr_out0,  yr_out1,  yr_out2,  yr_out3,
             yr_out4,  yr_out5,  yr_out6,  yr_out7,
             yr_out8,  yr_out9,  yr_out10, yr_out11,
             yr_out12, yr_out13, yr_out14, yr_out15 } =
           { s2_yr[0],  s2_yr[1],  s2_yr[2],  s2_yr[3],
             s2_yr[4],  s2_yr[5],  s2_yr[6],  s2_yr[7],
             s2_yr[8],  s2_yr[9],  s2_yr[10], s2_yr[11],
             s2_yr[12], s2_yr[13], s2_yr[14], s2_yr[15] };

    assign { yi_out0,  yi_out1,  yi_out2,  yi_out3,
             yi_out4,  yi_out5,  yi_out6,  yi_out7,
             yi_out8,  yi_out9,  yi_out10, yi_out11,
             yi_out12, yi_out13, yi_out14, yi_out15 } =
           { s2_yi[0],  s2_yi[1],  s2_yi[2],  s2_yi[3],
             s2_yi[4],  s2_yi[5],  s2_yi[6],  s2_yi[7],
             s2_yi[8],  s2_yi[9],  s2_yi[10], s2_yi[11],
             s2_yi[12], s2_yi[13], s2_yi[14], s2_yi[15] };

endmodule

