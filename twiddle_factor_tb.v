module twiddle_factor_tb;

    parameter WIDTH = 16;
    reg  [3:0] addr;
    wire signed [WIDTH-1:0] wr;
    wire signed [WIDTH-1:0] wi;

    // DUT
    twiddle_factor #(WIDTH) dut (.addr(addr), .wr(wr), .wi(wi));

    integer i;
    initial begin
        $display("\n================ Twiddle Factors (16-point FFT) ================");
        for (i = 0; i < 16; i = i + 1) begin
            addr = i;
            #2;
            $display("W16^%0d = %0d (real) , %0d (imag)", i, wr, wi);
        end
        $display("===============================================================");
        $finish;
    end
initial begin
    $shm_open("wave.shm");
    $shm_probe("ACTMF");
    #2000;
    $finish;
end
endmodule


