module stage2_butterfly_rounded_tb;
    parameter INW  = 16;
    parameter OUTW = 48;

    reg  signed [16*INW-1:0] xr_in_flat;
    reg  signed [16*INW-1:0] xi_in_flat;
    wire signed [16*OUTW-1:0] yr_out_flat;
    wire signed [16*OUTW-1:0] yi_out_flat;

    reg signed [OUTW-1:0] tmpr, tmpi;
    real real_r, real_i;
    integer i;
    
    stage2_butterfly_rounded #(INW, OUTW) dut (
        .xr_in_flat(xr_in_flat),
        .xi_in_flat(xi_in_flat),
        .yr_out_flat(yr_out_flat),
        .yi_out_flat(yi_out_flat)
    );

    task set_input;
        input integer idx;
        input integer r, im;
        begin
            xr_in_flat[idx*INW +: INW] = r;
            xi_in_flat[idx*INW +: INW] = im;
        end
    endtask

    initial begin
        xr_in_flat = 0; xi_in_flat = 0;

        // Stage1 buffer outputs
        set_input(0,  24, 0);
        set_input(1,  -8, 8);
        set_input(2,  -8, 0);
        set_input(3,  -8,-8);
        set_input(4,  28, 0);
        set_input(5,  -8, 8);
        set_input(6,  -8, 0);
        set_input(7,  -8,-8);
        set_input(8,  32, 0);
        set_input(9,  -8, 8);
        set_input(10, -8, 0);
        set_input(11, -8,-8);
        set_input(12, 36, 0);
        set_input(13, -8, 8);
        set_input(14, -8, 0);
        set_input(15, -8,-8);

        #10;
        $display("\n================= Stage2 Butterfly Results =================");
        for (i=0; i<16; i=i+1) begin
            tmpr = yr_out_flat[i*OUTW +: OUTW];
            tmpi = yi_out_flat[i*OUTW +: OUTW];
            real_r = $itor(tmpr)/32768.0;
            real_i = $itor(tmpi)/32768.0;

            // rounding to nearest integer
            real_r = $rtoi(real_r + (real_r>=0?0.5:-0.5));
            real_i = real_i; // keep j value float

            $display("X(%0d) = %0.0f %s %0.4fj",
                i, real_r, (real_i>=0)?"+":"-", (real_i>=0)?real_i:-real_i);
        end
        $display("============================================================\n");
        $finish;
    end
initial begin
    $shm_open("wave.shm");
    $shm_probe("ACTMF");
    #2000;
    $finish;
end
endmodule

