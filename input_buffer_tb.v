module input_buffer_tb;

    parameter N = 16;
    parameter WIDTH = 16;

    reg clk, rst, load;
    reg [3:0] addr_in;
    reg signed [WIDTH-1:0] xr_in;

    wire signed [WIDTH-1:0] xr_out0, xi_out0;

    // DUT instance
    input_buffer #(N, WIDTH) dut (
        .clk(clk),
        .rst(rst),
        .load(load),
        .addr_in(addr_in),
        .xr_in(xr_in),
        .xr_out0(xr_out0),
        .xi_out0(xi_out0)
    );

    // Clock
    initial clk = 0;
    always #5 clk = ~clk;

    integer i;

    reg signed [WIDTH-1:0] user_input [0:N-1];

    initial begin
        user_input[0]  =  0;
        user_input[1]  =  1;
        user_input[2]  =  2;
        user_input[3]  =  3;
        user_input[4]  =  4;
        user_input[5]  =  5;
        user_input[6]  =  6;
        user_input[7]  =  7;
        user_input[8]  =  8;
        user_input[9]  =  9;
        user_input[10] =  10;
        user_input[11] =  11;
        user_input[12] =  12;
        user_input[13] =  13;
        user_input[14] =  14;
        user_input[15] =  15;

        // Initialize
        clk = 0;
        rst = 1;
        load = 0;
        addr_in = 0;
        xr_in = 0;
        #10 rst = 0;

        // Load all samples into buffer
        for (i = 0; i < N; i = i + 1) begin
            @(posedge clk);
            load <= 1;
            addr_in <= i[3:0];
            xr_in <= user_input[i];
            @(posedge clk);
            load <= 0;
        end

        // Display stored data
        #20;
        $display("\n========= INPUT BUFFER CONTENTS =========");
        for (i = 0; i < N; i = i + 1)
            $display("Address %0d : Real = %0d, Imag = %0d", 
                     i, dut.xr_mem[i], dut.xi_mem[i]);
        $display("=========================================\n");

        $finish;
    end
initial begin
    $shm_open("wave.shm");
    $shm_probe("ACTMF");
    #2000;
    $finish;
end
endmodule

