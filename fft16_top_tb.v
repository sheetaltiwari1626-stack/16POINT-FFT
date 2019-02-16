
module fft16_top_tb;

    parameter WIDTH = 16;

    reg clk;
    reg rst;
    reg load;
    reg [3:0] addr_in;
    reg signed [WIDTH-1:0] xr_in;

    wire signed [WIDTH-1:0]
        yr_out0,  yr_out1,  yr_out2,  yr_out3,
        yr_out4,  yr_out5,  yr_out6,  yr_out7,
        yr_out8,  yr_out9,  yr_out10, yr_out11,
        yr_out12, yr_out13, yr_out14, yr_out15;

    wire signed [WIDTH-1:0]
        yi_out0,  yi_out1,  yi_out2,  yi_out3,
        yi_out4,  yi_out5,  yi_out6,  yi_out7,
        yi_out8,  yi_out9,  yi_out10, yi_out11,
        yi_out12, yi_out13, yi_out14, yi_out15;

    /* ===============================
       DUT
    =============================== */
    fft16_top #(
        .WIDTH(WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .load(load),
        .addr_in(addr_in),
        .xr_in(xr_in),

        .yr_out0(yr_out0),   .yr_out1(yr_out1),
        .yr_out2(yr_out2),   .yr_out3(yr_out3),
        .yr_out4(yr_out4),   .yr_out5(yr_out5),
        .yr_out6(yr_out6),   .yr_out7(yr_out7),
        .yr_out8(yr_out8),   .yr_out9(yr_out9),
        .yr_out10(yr_out10), .yr_out11(yr_out11),
        .yr_out12(yr_out12), .yr_out13(yr_out13),
        .yr_out14(yr_out14), .yr_out15(yr_out15),

        .yi_out0(yi_out0),   .yi_out1(yi_out1),
        .yi_out2(yi_out2),   .yi_out3(yi_out3),
        .yi_out4(yi_out4),   .yi_out5(yi_out5),
        .yi_out6(yi_out6),   .yi_out7(yi_out7),
        .yi_out8(yi_out8),   .yi_out9(yi_out9),
        .yi_out10(yi_out10), .yi_out11(yi_out11),
        .yi_out12(yi_out12), .yi_out13(yi_out13),
        .yi_out14(yi_out14), .yi_out15(yi_out15)
    );

    /* ===============================
       Clock (100 MHz)
    =============================== */
    always #5 clk = ~clk;

    /* ===============================
       Test Procedure
    =============================== */
    integer i;

    initial begin
        clk = 0;
        rst = 1;
        load = 0;
        addr_in = 0;
        xr_in = 0;

        // Reset
        #20;
        rst = 0;

        // Load input samples (Impulse)
        // x[0] = 1.0 (Q1.15 = 32767), others = 0
        for (i = 0; i < 16; i = i + 1) begin
            @(posedge clk);
            load    <= 1;
            addr_in <= i[3:0];
            if (i == 0)
                xr_in <= 16'sd32767;
            else
                xr_in <= 16'sd0;
        end

        @(posedge clk);
        load <= 0;

        // Wait for FFT to settle
        #100;

        // Display FFT output
        $display("========================================");
        $display("FFT OUTPUT (REAL , IMAG)");
        $display("========================================");
        $display("Y[0]  = %d , %d", yr_out0,  yi_out0);
        $display("Y[1]  = %d , %d", yr_out1,  yi_out1);
        $display("Y[2]  = %d , %d", yr_out2,  yi_out2);
        $display("Y[3]  = %d , %d", yr_out3,  yi_out3);
        $display("Y[4]  = %d , %d", yr_out4,  yi_out4);
        $display("Y[5]  = %d , %d", yr_out5,  yi_out5);
        $display("Y[6]  = %d , %d", yr_out6,  yi_out6);
        $display("Y[7]  = %d , %d", yr_out7,  yi_out7);
        $display("Y[8]  = %d , %d", yr_out8,  yi_out8);
        $display("Y[9]  = %d , %d", yr_out9,  yi_out9);
        $display("Y[10] = %d , %d", yr_out10, yi_out10);
        $display("Y[11] = %d , %d", yr_out11, yi_out11);
        $display("Y[12] = %d , %d", yr_out12, yi_out12);
        $display("Y[13] = %d , %d", yr_out13, yi_out13);
        $display("Y[14] = %d , %d", yr_out14, yi_out14);
        $display("Y[15] = %d , %d", yr_out15, yi_out15);
        $display("========================================");

        #20;
        $stop;
    end

endmodule

