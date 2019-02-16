module fft_top_tb;

    parameter N = 16;
    parameter WIDTH = 16;
    parameter OUTW = 48;

    reg clk, rst, load;
    reg [3:0] addr_in;

    reg  signed [N*WIDTH-1:0] xr_in_flat;
    reg  signed [N*WIDTH-1:0] xi_in_flat;

    wire signed [N*OUTW-1:0] yr_final_flat;
    wire signed [N*OUTW-1:0] yi_final_flat;

    integer i;
    integer hi, lo;   // << FIXED: moved declarations to module level

    // Instantiate TOP
    fft_top dut (
        .clk(clk),
        .rst(rst),
        .load(load),
        .addr_in(addr_in),
        .xr_in_flat(xr_in_flat),
        .xi_in_flat(xi_in_flat),
        .yr_final_flat(yr_final_flat),
        .yi_final_flat(yi_final_flat)
    );

    // Clock
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        load = 0;
        xr_in_flat = 0;
        xi_in_flat = 0;

        #20 rst = 0;

        // LOAD 16 SAMPLES
        load = 1;
        for (i = 0; i < N; i = i + 1) begin
            addr_in = i;

            // correct indexed part-select
            xr_in_flat[i*WIDTH +: WIDTH] = 16'sd1000;
            xi_in_flat[i*WIDTH +: WIDTH] = 16'sd0;

            #10;
        end
        load = 0;

        #200;

        // DISPLAY OUTPUT
        $display("\n---- FFT OUTPUT ----\n");
        for (i = 0; i < N; i = i + 1) begin
            hi = (i+1)*OUTW - 1;
            lo =  i*OUTW;

            $display("Y[%0d] = %d  +  j%d",
                     i,
                     yr_final_flat[lo +: OUTW],
                     yi_final_flat[lo +: OUTW]);
        end

        $finish;
    end


initial begin
    $shm_open("wave.shm");
    $shm_probe("ACTMF");
    #2000;
    $finish;
end

endmodule

