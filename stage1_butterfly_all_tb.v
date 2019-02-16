module stage1_butterfly_all_tb;

parameter WIDTH = 16;
integer i;

reg signed [WIDTH-1:0] xr_in [0:15];
reg signed [WIDTH-1:0] xi_in [0:15];

wire signed [WIDTH-1:0] yr_out [0:15];
wire signed [WIDTH-1:0] yi_out [0:15];

stage1_butterfly_all #(WIDTH) dut (
    .xr_in0(xr_in[0]),  .xr_in1(xr_in[1]),  .xr_in2(xr_in[2]),  .xr_in3(xr_in[3]),
    .xr_in4(xr_in[4]),  .xr_in5(xr_in[5]),  .xr_in6(xr_in[6]),  .xr_in7(xr_in[7]),
    .xr_in8(xr_in[8]),  .xr_in9(xr_in[9]),  .xr_in10(xr_in[10]),.xr_in11(xr_in[11]),
    .xr_in12(xr_in[12]),.xr_in13(xr_in[13]),.xr_in14(xr_in[14]),.xr_in15(xr_in[15]),

    .xi_in0(xi_in[0]),  .xi_in1(xi_in[1]),  .xi_in2(xi_in[2]),  .xi_in3(xi_in[3]),
    .xi_in4(xi_in[4]),  .xi_in5(xi_in[5]),  .xi_in6(xi_in[6]),  .xi_in7(xi_in[7]),
    .xi_in8(xi_in[8]),  .xi_in9(xi_in[9]),  .xi_in10(xi_in[10]),.xi_in11(xi_in[11]),
    .xi_in12(xi_in[12]),.xi_in13(xi_in[13]),.xi_in14(xi_in[14]),.xi_in15(xi_in[15]),

    .yr_out0(yr_out[0]),  .yr_out1(yr_out[1]),  .yr_out2(yr_out[2]),  .yr_out3(yr_out[3]),
    .yr_out4(yr_out[4]),  .yr_out5(yr_out[5]),  .yr_out6(yr_out[6]),  .yr_out7(yr_out[7]),
    .yr_out8(yr_out[8]),  .yr_out9(yr_out[9]),  .yr_out10(yr_out[10]),.yr_out11(yr_out[11]),
    .yr_out12(yr_out[12]),.yr_out13(yr_out[13]),.yr_out14(yr_out[14]),.yr_out15(yr_out[15]),

    .yi_out0(yi_out[0]),  .yi_out1(yi_out[1]),  .yi_out2(yi_out[2]),  .yi_out3(yi_out[3]),
    .yi_out4(yi_out[4]),  .yi_out5(yi_out[5]),  .yi_out6(yi_out[6]),  .yi_out7(yi_out[7]),
    .yi_out8(yi_out[8]),  .yi_out9(yi_out[9]),  .yi_out10(yi_out[10]),.yi_out11(yi_out[11]),
    .yi_out12(yi_out[12]),.yi_out13(yi_out[13]),.yi_out14(yi_out[14]),.yi_out15(yi_out[15])
);

initial begin
    // Inputs (real)
    xr_in[0]=0;  xr_in[1]=1;  xr_in[2]=2;  xr_in[3]=3;
    xr_in[4]=4;  xr_in[5]=5;  xr_in[6]=6;  xr_in[7]=7;
    xr_in[8]=8;  xr_in[9]=9;  xr_in[10]=10;xr_in[11]=11;
    xr_in[12]=12;xr_in[13]=13;xr_in[14]=14;xr_in[15]=15;
    for (i=0; i<16; i=i+1)
        xi_in[i]=0;

    #10;

    $display("\n==================== Stage1 Butterfly Outputs (All Groups) ====================");
    for (i=0; i<16; i=i+1)
        $display("Index %0d : Real = %0d , Imag = %0d", i, yr_out[i], yi_out[i]);
    $display("=============================================================================");
    $finish;
end

initial begin
    $shm_open("wave.shm");
    $shm_probe("ACTIMF");
    #2000;
    $finish;
end

endmodule

