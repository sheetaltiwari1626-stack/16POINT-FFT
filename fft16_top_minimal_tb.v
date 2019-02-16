module fft16_top_minimal_tb;
    reg clk, rst, load;
    reg [3:0] addr_in;
    reg signed [15:0] xr_in;
    wire [255:0] st1_yr, st1_yi;

    fft16_top_minimal uut (
        .clk(clk),
        .rst(rst),
        .load(load),
        .addr_in(addr_in),
        .xr_in(xr_in),
        .st1_yr(st1_yr),
        .st1_yi(st1_yi)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1; load = 0; addr_in = 0; xr_in = 0;
        #20; rst = 0; #10;
        load = 1;
        for (addr_in = 0; addr_in < 16; addr_in = addr_in + 1) begin
            xr_in = addr_in; // Example: count input
            #10;
        end
        load = 0; xr_in = 0;
        #100; // Wait for outputs

        $display("Stage1 Butterfly Outputs:");
        $display("Index | Real | Imag");
        $display("-------------------");
        $display("0 | %d | %d", st1_yr[15:0],   st1_yi[15:0]);
        $display("1 | %d | %d", st1_yr[31:16],  st1_yi[31:16]);
        $display("2 | %d | %d", st1_yr[47:32],  st1_yi[47:32]);
        $display("3 | %d | %d", st1_yr[63:48],  st1_yi[63:48]);
        $display("4 | %d | %d", st1_yr[79:64],  st1_yi[79:64]);
        $display("5 | %d | %d", st1_yr[95:80],  st1_yi[95:80]);
        $display("6 | %d | %d", st1_yr[111:96], st1_yi[111:96]);
        $display("7 | %d | %d", st1_yr[127:112],st1_yi[127:112]);
        $display("8 | %d | %d", st1_yr[143:128],st1_yi[143:128]);
        $display("9 | %d | %d", st1_yr[159:144],st1_yi[159:144]);
        $display("10 | %d | %d", st1_yr[175:160],st1_yi[175:160]);
        $display("11 | %d | %d", st1_yr[191:176],st1_yi[191:176]);
        $display("12 | %d | %d", st1_yr[207:192],st1_yi[207:192]);
        $display("13 | %d | %d", st1_yr[223:208],st1_yi[223:208]);
        $display("14 | %d | %d", st1_yr[239:224],st1_yi[239:224]);
        $display("15 | %d | %d", st1_yr[255:240],st1_yi[255:240]);
        #20; $finish;
    end
initial begin
    $shm_open("wave.shm");
    $shm_probe("ACTMF");
    #2000;
    $finish;
end
endmodule

