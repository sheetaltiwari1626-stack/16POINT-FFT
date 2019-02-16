module fft_top_from_buffers_tb;

    parameter N = 16;
    parameter WIDTH = 16;
    parameter INW2 = 16;
    parameter OUTW2 = 48;

    reg clk, rst;
    reg load;
    reg [3:0] addr_in;
    reg signed [WIDTH-1:0] xr_in;
    reg capture_req;

    wire signed [N*OUTW2-1:0] yr_stage2_flat;
    wire signed [N*OUTW2-1:0] yi_stage2_flat;

    // Instantiate top
    fft_top_from_buffers #(.N(N), .WIDTH(WIDTH), .INW2(INW2), .OUTW2(OUTW2)) dut (
        .clk(clk),
        .rst(rst),
        .load(load),
        .addr_in(addr_in),
        .xr_in(xr_in),
        .capture_req(capture_req),
        .yr_stage2_flat(yr_stage2_flat),
        .yi_stage2_flat(yi_stage2_flat)
    );

    integer i;
    integer hi, lo;
    reg signed [OUTW2-1:0] out_r;
    reg signed [OUTW2-1:0] out_i;

    // clock
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // init
        rst = 1;
        load = 0;
        addr_in = 4'd0;
        xr_in = 0;
        capture_req = 0;

        #20;
        rst = 0;
        #10;

        // write 16 samples into input buffer
        // note: input_buffer expects load high and addr_in set externally
        for (i = 0; i < N; i = i + 1) begin
            @(posedge clk);
            load <= 1;
            addr_in <= i[3:0];
            xr_in <= i * 16'sd100; // example ramp scaled
            @(posedge clk);
            load <= 0;
        end

        // small delay
        #20;

        // Now capture: we will pulse capture_req and at each clock drive addr_in = 0..15
        // The top module latches buf outputs into its internal arrays when capture_req is asserted.
        // Drive capture cycle
        @(posedge clk);
        capture_req <= 1;
        // during capture, present read addresses on addr_in each clock
        for (i = 0; i < N; i = i + 1) begin
            @(posedge clk);
            addr_in <= i[3:0];
        end
        @(posedge clk);
        capture_req <= 0;

        // allow pipeline to compute
        #50;

        // Display stage-2 flattened outputs
        $display("\n==== Stage-2 outputs ====");
        for (i = 0; i < N; i = i + 1) begin
            hi = (i+1)*OUTW2 - 1;
            lo = i*OUTW2;
            out_r = yr_stage2_flat[lo +: OUTW2];
            out_i = yi_stage2_flat[lo +: OUTW2];
            $display("X(%0d): Real=%0d  Imag=%0d", i, out_r, out_i);
        end

        #50;
        $finish;
    end

    // wave dump
    initial begin
        $dumpfile("fft_top_from_buffers.vcd");
        $dumpvars(0, fft_top_from_buffers_tb);
    end
initial begin
    $shm_open("wave.shm");
    $shm_probe("ACTMF");
    #2000;
    $finish;
end

endmodule

