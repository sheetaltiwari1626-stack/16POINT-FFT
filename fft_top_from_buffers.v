module fft_top_from_buffers #(
    parameter N    = 16,
    parameter WIDTH = 16,   // stage1 sample width
    parameter INW2  = 16,   // stage2 input width (after any twiddle) - here same as WIDTH
    parameter OUTW2 = 48    // stage2 accumulator output width
)(
    input  wire              clk,
    input  wire              rst,

    // interface to write input samples into input_buffer
    input  wire              load,          // high when writing a sample (driven by TB)
    input  wire [3:0]        addr_in,       // address for input_buffer (0..15)
    input  wire signed [WIDTH-1:0] xr_in,   // real input (user provides)

    // capture control: when asserted high for one clock the top will read all N samples
    input  wire              capture_req,   // TB pulses this to request capture of all samples

    // outputs: flattened stage-2 result
    output wire signed [N*OUTW2-1:0] yr_stage2_flat,
    output wire signed [N*OUTW2-1:0] yi_stage2_flat
);

    // -----------------------------
    // instantiate input_buffer
    // -----------------------------
    wire signed [WIDTH-1:0] buf_xr_out;
    wire signed [WIDTH-1:0] buf_xi_out;

    input_buffer #(.N(N), .WIDTH(WIDTH)) input_buf (
        .clk(clk),
        .rst(rst),
        .load(load),
        .addr_in(addr_in),
        .xr_in(xr_in),
        .xr_out0(buf_xr_out),
        .xi_out0(buf_xi_out)
    );

    // -----------------------------
    // Capture RAM (on capture_req): cycle addresses 0..N-1 and capture outputs
    // -----------------------------
    reg [3:0] read_addr;
    reg capturing;
    integer ii;

    // stage1 inputs (captured)
    reg signed [WIDTH-1:0] s1_in_r [0:N-1];
    reg signed [WIDTH-1:0] s1_in_i [0:N-1];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            read_addr <= 4'd0;
            capturing <= 1'b0;
            for (ii = 0; ii < N; ii = ii + 1) begin
                s1_in_r[ii] <= {WIDTH{1'b0}};
                s1_in_i[ii] <= {WIDTH{1'b0}};
            end
        end else begin
            // start capture on rising edge of capture_req
            if (capture_req && !capturing) begin
                capturing <= 1'b1;
                read_addr <= 4'd0;
            end else if (capturing) begin
                // set input_buffer address to read_addr through hierarchical write:
                // But we cannot drive input_buf.addr_in from here (it's driven externally for writing).
                // Instead, capture by driving a local read request: we assume input_buffer's output
                // (buf_xr_out, buf_xi_out) reflect currently-addressed location by external addr_in.
                // Therefore TB must drive addr_in to the read address while capture_req is asserted.
                // To make it robust, we require TB to drive addr_in in sync with capture_req.
                //
                // For simplicity: TB will on each clock set addr_in externally; here we only latch outputs.
                s1_in_r[read_addr] <= buf_xr_out;
                s1_in_i[read_addr] <= buf_xi_out;

                if (read_addr == (N-1)) begin
                    capturing <= 1'b0;
                    read_addr <= 4'd0;
                end else begin
                    read_addr <= read_addr + 1'b1;
                end
            end
        end
    end

    // -----------------------------
    // Now we have s1_in_r/s1_in_i arrays. Feed them to stage1 butterfly.
    // stagel_butterfly_all requires many scalar ports; wire those arrays to the module.
    // -----------------------------
    wire signed [WIDTH-1:0] xr_s1_w [0:15];
    wire signed [WIDTH-1:0] xi_s1_w [0:15];

    genvar g;
    generate
        for (g = 0; g < N; g = g + 1) begin : CONNECT_CAPTURE_TO_STAGE1
            assign xr_s1_w[g] = s1_in_r[g];
            assign xi_s1_w[g] = s1_in_i[g];
        end
    endgenerate

    // wires for stage1 outputs
    wire signed [WIDTH-1:0] s1r [0:15];
    wire signed [WIDTH-1:0] s1i [0:15];

    stage1_butterfly_all #(.WIDTH(WIDTH)) stage1 (
        .xr_in0 (xr_s1_w[0]),  .xr_in1 (xr_s1_w[1]),  .xr_in2 (xr_s1_w[2]),  .xr_in3 (xr_s1_w[3]),
        .xr_in4 (xr_s1_w[4]),  .xr_in5 (xr_s1_w[5]),  .xr_in6 (xr_s1_w[6]),  .xr_in7 (xr_s1_w[7]),
        .xr_in8 (xr_s1_w[8]),  .xr_in9 (xr_s1_w[9]),  .xr_in10(xr_s1_w[10]), .xr_in11(xr_s1_w[11]),
        .xr_in12(xr_s1_w[12]), .xr_in13(xr_s1_w[13]), .xr_in14(xr_s1_w[14]), .xr_in15(xr_s1_w[15]),

        .xi_in0 (xi_s1_w[0]),  .xi_in1 (xi_s1_w[1]),  .xi_in2 (xi_s1_w[2]),  .xi_in3 (xi_s1_w[3]),
        .xi_in4 (xi_s1_w[4]),  .xi_in5 (xi_s1_w[5]),  .xi_in6 (xi_s1_w[6]),  .xi_in7 (xi_s1_w[7]),
        .xi_in8 (xi_s1_w[8]),  .xi_in9 (xi_s1_w[9]),  .xi_in10(xi_s1_w[10]), .xi_in11(xi_s1_w[11]),
        .xi_in12(xi_s1_w[12]), .xi_in13(xi_s1_w[13]), .xi_in14(xi_s1_w[14]), .xi_in15(xi_s1_w[15]),

        .yr_out0 (s1r[0]),  .yr_out1 (s1r[1]),  .yr_out2 (s1r[2]),  .yr_out3 (s1r[3]),
        .yr_out4 (s1r[4]),  .yr_out5 (s1r[5]),  .yr_out6 (s1r[6]),  .yr_out7 (s1r[7]),
        .yr_out8 (s1r[8]),  .yr_out9 (s1r[9]),  .yr_out10(s1r[10]), .yr_out11(s1r[11]),
        .yr_out12(s1r[12]), .yr_out13(s1r[13]), .yr_out14(s1r[14]), .yr_out15(s1r[15]),

        .yi_out0 (s1i[0]),  .yi_out1 (s1i[1]),  .yi_out2 (s1i[2]),  .yi_out3 (s1i[3]),
        .yi_out4 (s1i[4]),  .yi_out5 (s1i[5]),  .yi_out6 (s1i[6]),  .yi_out7 (s1i[7]),
        .yi_out8 (s1i[8]),  .yi_out9 (s1i[9]),  .yi_out10(s1i[10]), .yi_out11(s1i[11]),
        .yi_out12(s1i[12]), .yi_out13(s1i[13]), .yi_out14(s1i[14]), .yi_out15(s1i[15])
    );

    // -----------------------------
    // stage1_buffer (pass-through)
    // -----------------------------
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

    // -----------------------------
    // Pack buffer outputs into flattened stage-2 input vectors
    // -----------------------------
    wire signed [N*INW2-1:0] xr_s2_flat;
    wire signed [N*INW2-1:0] xi_s2_flat;

    generate
        for (g = 0; g < N; g = g + 1) begin : PACK_S2
            // explicit constant-range assignments (generate-time constants)
            assign xr_s2_flat[(g+1)*INW2-1 : g*INW2] = buf_r[g];
            assign xi_s2_flat[(g+1)*INW2-1 : g*INW2] = buf_i[g];
        end
    endgenerate

    // -----------------------------
    // stage2 butterfly rounded
    // -----------------------------
    stage2_butterfly_rounded #(.INW(INW2), .OUTW(OUTW2)) stage2 (
        .xr_in_flat(xr_s2_flat),
        .xi_in_flat(xi_s2_flat),
        .yr_out_flat(yr_stage2_flat),
        .yi_out_flat(yi_stage2_flat)
    );

endmodule

