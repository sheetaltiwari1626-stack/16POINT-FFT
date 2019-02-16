
// fft_top.v
// Top-level FFT pipeline: stage1 -> stage1_buffer -> twiddle multiply -> stage2
// Uploaded reference image (for traceability): file:///mnt/data/stage1but.jpg

module fft_top #(
    parameter WIDTH  = 16,   // width of stage1 samples (per real/imag)
    parameter TWW    = 16,   // twiddle width (Q1.15)
    parameter INW2   = 16,   // width input to stage2 (after twiddle)
    parameter OUTW2  = 48    // width output from stage2 (accumulator output)
)(
    input  wire signed [16*WIDTH-1:0] xr_s1_in_flat,
    input  wire signed [16*WIDTH-1:0] xi_s1_in_flat,
    output wire signed [16*OUTW2-1:0] yr_stage2_flat,
    output wire signed [16*OUTW2-1:0] yi_stage2_flat
);

    // ------------------------------------------------------------------
    // 1) Unpack stage-1 flattened inputs into arrays
    // ------------------------------------------------------------------
    wire signed [WIDTH-1:0] xr_s1_in [0:15];
    wire signed [WIDTH-1:0] xi_s1_in [0:15];
    genvar gi;
    generate
        for (gi = 0; gi < 16; gi = gi + 1) begin : UNPACK_S1
            assign xr_s1_in[gi] = xr_s1_in_flat[(gi+1)*WIDTH-1 : gi*WIDTH];
            assign xi_s1_in[gi] = xi_s1_in_flat[(gi+1)*WIDTH-1 : gi*WIDTH];
        end
    endgenerate

    // ------------------------------------------------------------------
    // 2) Stage-1 butterfly (4 groups of 4-point DFT)
    // ------------------------------------------------------------------
    wire signed [WIDTH-1:0] s1r [0:15];
    wire signed [WIDTH-1:0] s1i [0:15];

    stagel_butterfly_all #(.WIDTH(WIDTH)) stage1 (
        .xr_in0 (xr_s1_in[0]),  .xr_in1 (xr_s1_in[1]),  .xr_in2 (xr_s1_in[2]),  .xr_in3 (xr_s1_in[3]),
        .xr_in4 (xr_s1_in[4]),  .xr_in5 (xr_s1_in[5]),  .xr_in6 (xr_s1_in[6]),  .xr_in7 (xr_s1_in[7]),
        .xr_in8 (xr_s1_in[8]),  .xr_in9 (xr_s1_in[9]),  .xr_in10(xr_s1_in[10]), .xr_in11(xr_s1_in[11]),
        .xr_in12(xr_s1_in[12]), .xr_in13(xr_s1_in[13]), .xr_in14(xr_s1_in[14]), .xr_in15(xr_s1_in[15]),

        .xi_in0 (xi_s1_in[0]),  .xi_in1 (xi_s1_in[1]),  .xi_in2 (xi_s1_in[2]),  .xi_in3 (xi_s1_in[3]),
        .xi_in4 (xi_s1_in[4]),  .xi_in5 (xi_s1_in[5]),  .xi_in6 (xi_s1_in[6]),  .xi_in7 (xi_s1_in[7]),
        .xi_in8 (xi_s1_in[8]),  .xi_in9 (xi_s1_in[9]),  .xi_in10(xi_s1_in[10]), .xi_in11(xi_s1_in[11]),
        .xi_in12(xi_s1_in[12]), .xi_in13(xi_s1_in[13]), .xi_in14(xi_s1_in[14]), .xi_in15(xi_s1_in[15]),

        .yr_out0 (s1r[0]),  .yr_out1 (s1r[1]),  .yr_out2 (s1r[2]),  .yr_out3 (s1r[3]),
        .yr_out4 (s1r[4]),  .yr_out5 (s1r[5]),  .yr_out6 (s1r[6]),  .yr_out7 (s1r[7]),
        .yr_out8 (s1r[8]),  .yr_out9 (s1r[9]),  .yr_out10(s1r[10]), .yr_out11(s1r[11]),
        .yr_out12(s1r[12]), .yr_out13(s1r[13]), .yr_out14(s1r[14]), .yr_out15(s1r[15]),

        .yi_out0 (s1i[0]),  .yi_out1 (s1i[1]),  .yi_out2 (s1i[2]),  .yi_out3 (s1i[3]),
        .yi_out4 (s1i[4]),  .yi_out5 (s1i[5]),  .yi_out6 (s1i[6]),  .yi_out7 (s1i[7]),
        .yi_out8 (s1i[8]),  .yi_out9 (s1i[9]),  .yi_out10(s1i[10]), .yi_out11(s1i[11]),
        .yi_out12(s1i[12]), .yi_out13(s1i[13]), .yi_out14(s1i[14]), .yi_out15(s1i[15])
    );

    // ------------------------------------------------------------------
    // 3) Stage-1 buffer (pass-through)
    // ------------------------------------------------------------------
    wire signed [WIDTH-1:0] buf_r [0:15];
    wire signed [WIDTH-1:0] buf_i [0:15];

    stage1_buffer #(.WIDTH(WIDTH)) s1buf (
        .yr_in0 (s1r[0]),  .yr_in1 (s1r[1]),  .yr_in2 (s1r[2]),  .yr_in3 (s1r[3]),
        .yr_in4 (s1r[4]),  .yr_in5 (s1r[5]),  .yr_in6 (s1r[6]),  .yr_in7 (s1r[7]),
        .yr_in8 (s1r[8]),  .yr_in9 (s1r[9]),  .yr_in10(s1r[10]), .yr_in11(s1r[11]),
        .yr_in12(s1r[12]), .yr_in13(s1r[13]), .yr_in14(s1r[14]), .yr_in15(s1r[15]),

        .yi_in0 (s1i[0]),  .yi_in1 (s1i[1]),  .yi_in2 (s1i[2]),  .yi_in3 (s1i[3]),
        .yi_in4 (s1i[4]),  .yi_in5 (s1i[5]),  .yi_in6 (s1i[6]),  .yi_in7 (s1i[7]),
        .yi_in8 (s1i[8]),  .yi_in9 (s1i[9]),  .yi_in10(s1i[10]), .yi_in11(s1i[11]),
        .yi_in12(s1i[12]), .yi_in13(s1i[13]), .yi_in14(s1i[14]), .yi_in15(s1i[15]),

        .yr_out0 (buf_r[0]),  .yr_out1 (buf_r[1]),  .yr_out2 (buf_r[2]),  .yr_out3 (buf_r[3]),
        .yr_out4 (buf_r[4]),  .yr_out5 (buf_r[5]),  .yr_out6 (buf_r[6]),  .yr_out7 (buf_r[7]),
        .yr_out8 (buf_r[8]),  .yr_out9 (buf_r[9]),  .yr_out10(buf_r[10]), .yr_out11(buf_r[11]),
        .yr_out12(buf_r[12]), .yr_out13(buf_r[13]), .yr_out14(buf_r[14]), .yr_out15(buf_r[15]),

        .yi_out0 (buf_i[0]),  .yi_out1 (buf_i[1]),  .yi_out2 (buf_i[2]),  .yi_out3 (buf_i[3]),
        .yi_out4 (buf_i[4]),  .yi_out5 (buf_i[5]),  .yi_out6 (buf_i[6]),  .yi_out7 (buf_i[7]),
        .yi_out8 (buf_i[8]),  .yi_out9 (buf_i[9]),  .yi_out10(buf_i[10]), .yi_out11(buf_i[11]),
        .yi_out12(buf_i[12]), .yi_out13(buf_i[13]), .yi_out14(buf_i[14]), .yi_out15(buf_i[15])
    );

    // ------------------------------------------------------------------
    // 4) Twiddle factors (instantiate one twiddle_factor per index)
    // ------------------------------------------------------------------
    wire signed [TWW-1:0] Wr [0:15];
    wire signed [TWW-1:0] Wi [0:15];
    genvar ti;
    generate
        for (ti = 0; ti < 16; ti = ti + 1) begin : TW_GEN
            twiddle_factor #(.WIDTH(TWW)) TF (
                .addr(ti[3:0]),
                .wr(Wr[ti]),
                .wi(Wi[ti])
            );
        end
    endgenerate

    // ------------------------------------------------------------------
    // 5) Multiply buffer outputs by twiddle factors (Q1.15)
    // tw_r/tw_i are regs because assigned in always block
    // ------------------------------------------------------------------
    reg signed [INW2-1:0] tw_r [0:15];
    reg signed [INW2-1:0] tw_i [0:15];

    integer jj;
    reg signed [31:0] mult_pr;
    reg signed [31:0] mult_pi;
    reg signed [31:0] pr_shifted;
    reg signed [31:0] pi_shifted;

    always @(*) begin
        for (jj = 0; jj < 16; jj = jj + 1) begin
            mult_pr = (buf_r[jj] * Wr[jj]) - (buf_i[jj] * Wi[jj]);
            mult_pi = (buf_r[jj] * Wi[jj]) + (buf_i[jj] * Wr[jj]);
            pr_shifted = mult_pr >>> 15;
            pi_shifted = mult_pi >>> 15;
            tw_r[jj] = pr_shifted[INW2-1:0];
            tw_i[jj] = pi_shifted[INW2-1:0];
        end
    end

    // ------------------------------------------------------------------
    // 6) Pack twiddle results into stage-2 flattened inputs
    // ------------------------------------------------------------------
    wire signed [16*INW2-1:0] xr_s2_flat;
    wire signed [16*INW2-1:0] xi_s2_flat;
    generate
        for (gi = 0; gi < 16; gi = gi + 1) begin : PACK_S2
            assign xr_s2_flat[(gi+1)*INW2-1 : gi*INW2] = tw_r[gi];
            assign xi_s2_flat[(gi+1)*INW2-1 : gi*INW2] = tw_i[gi];
        end
    endgenerate

    // ------------------------------------------------------------------
    // 7) Stage-2 butterfly rounded (expects flattened 16*INW2 inputs)
    // ------------------------------------------------------------------
    stage2_butterfly_rounded #(.INW(INW2), .OUTW(OUTW2)) stage2 (
        .xr_in_flat(xr_s2_flat),
        .xi_in_flat(xi_s2_flat),
        .yr_out_flat(yr_stage2_flat),
        .yi_out_flat(yi_stage2_flat)
    );

endmodule

