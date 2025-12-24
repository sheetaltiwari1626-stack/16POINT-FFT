module fft16_radix4_top_tb;
  parameter N = 16;
  parameter WIDTH = 16;
  parameter OUTW = 48;

  reg clk, rst, load;
  reg [3:0] addr_in;
  reg signed [WIDTH-1:0] xr_in;
  
  wire signed [WIDTH-1:0] xr_out0, xi_out0;
  wire signed [N*OUTW-1:0] yr_stage2_flat, yi_stage2_flat;
  
  integer i, j;
  reg signed [WIDTH-1:0] user_input [0:N-1];
  reg signed [OUTW-1:0] yr_temp, yi_temp;
  real out_r, out_i;

  fft16_radix4_top #(
    .N(N),
    .WIDTH(WIDTH),
    .OUTW(OUTW)
  ) dut (
    .clk(clk),
    .rst(rst),
    .load(load),
    .addr_in(addr_in),
    .xr_in(xr_in),
    .xr_out0(xr_out0),
    .xi_out0(xi_out0),
    .yr_stage2_flat(yr_stage2_flat),
    .yi_stage2_flat(yi_stage2_flat)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    rst = 1;
    load = 0;
    addr_in = 0;
    xr_in = 0;
    
    user_input[0] = 0;
    user_input[1] = 1;
    user_input[2] = 2;
    user_input[3] = 3;
    user_input[4] = 4;
    user_input[5] = 5;
    user_input[6] = 6;
    user_input[7] = 7;
    user_input[8] = 8;
    user_input[9] = 9;
    user_input[10] = 10;
    user_input[11] = 11;
    user_input[12] = 12;
    user_input[13] = 13;
    user_input[14] = 14;
    user_input[15] = 15;
    #10 rst = 0;
    #10;
    
    for (i = 0; i < N; i = i + 1) begin
      @(posedge clk);
      addr_in = i;
      xr_in = user_input[i];
      load = 1;
      @(posedge clk);
      load = 0;
    end
    #100;
    // Display results
    $display("\n========== INPUT BUFFER CONTENTS ==========");
    for (i = 0; i < N; i = i + 1) begin
      $display("Address %0d : Real = %0d, Imag = %0d", 
               i, dut.inbuf_inst.xr_mem[i], dut.inbuf_inst.xi_mem[i]);
    end
    
    $display("\n========== STAGE1 BUTTERFLY OUTPUTS ==========");
    for (i = 0; i < N; i = i + 1) begin
      $display("Index %0d : Real = %0d, Imag = %0d", 
               i, dut.yr_stage1[i], dut.yi_stage1[i]);
    end
    
    $display("\n========== STAGE1 BUFFER OUTPUTS ==========");
    for (i = 0; i < N; i = i + 1) begin
      $display("Index %0d : Real = %0d, Imag = %0d", 
               i, dut.yr_buf[i], dut.yi_buf[i]);
    end
    
    $display("\n========== FINAL FFT OUTPUTS (STAGE2) ==========");
    for (i = 0; i < N; i = i + 1) begin
      j = i * OUTW;
      yr_temp = yr_stage2_flat[j +: OUTW];
      yi_temp = yi_stage2_flat[j +: OUTW];
      out_r = $itor(yr_temp) / 32768.0;
      out_i = $itor(yi_temp) / 32768.0;
      
      if (out_i >= 0)
        $display("X(%0d) = %0.4f + %0.4fj", i, out_r, out_i);
      else
        $display("X(%0d) = %0.4f - %0.4fj", i, out_r, -out_i);
    end
    $display("====================================================\n");
    
    #100;
    $finish;
  end
  initial begin
    $shm_open("wave.shm");
    $shm_probe("ACTMF");
  end
endmodule

