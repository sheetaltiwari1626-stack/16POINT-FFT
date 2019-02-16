module stage1_butterfly_all #(parameter WIDTH=16)(
    input  wire signed [WIDTH-1:0] xr_in0, xr_in1, xr_in2, xr_in3,
    input  wire signed [WIDTH-1:0] xr_in4, xr_in5, xr_in6, xr_in7,
    input  wire signed [WIDTH-1:0] xr_in8, xr_in9, xr_in10, xr_in11,
    input  wire signed [WIDTH-1:0] xr_in12, xr_in13, xr_in14, xr_in15,

    input  wire signed [WIDTH-1:0] xi_in0, xi_in1, xi_in2, xi_in3,
    input  wire signed [WIDTH-1:0] xi_in4, xi_in5, xi_in6, xi_in7,
    input  wire signed [WIDTH-1:0] xi_in8, xi_in9, xi_in10, xi_in11,
    input  wire signed [WIDTH-1:0] xi_in12, xi_in13, xi_in14, xi_in15,

    output reg  signed [WIDTH-1:0] yr_out0, yr_out1, yr_out2, yr_out3,
    output reg  signed [WIDTH-1:0] yr_out4, yr_out5, yr_out6, yr_out7,
    output reg  signed [WIDTH-1:0] yr_out8, yr_out9, yr_out10, yr_out11,
    output reg  signed [WIDTH-1:0] yr_out12, yr_out13, yr_out14, yr_out15,

    output reg  signed [WIDTH-1:0] yi_out0, yi_out1, yi_out2, yi_out3,
    output reg  signed [WIDTH-1:0] yi_out4, yi_out5, yi_out6, yi_out7,
    output reg  signed [WIDTH-1:0] yi_out8, yi_out9, yi_out10, yi_out11,
    output reg  signed [WIDTH-1:0] yi_out12, yi_out13, yi_out14, yi_out15
);

    integer g;
    reg signed [WIDTH-1:0] xr [0:15];
    reg signed [WIDTH-1:0] xi [0:15];
    reg signed [WIDTH-1:0] yr [0:15];
    reg signed [WIDTH-1:0] yi [0:15];

    reg signed [WIDTH-1:0] xr0, xr1, xr2, xr3;
    reg signed [WIDTH-1:0] xi0, xi1, xi2, xi3;
    reg signed [WIDTH-1:0] yr0, yr1, yr2, yr3;
    reg signed [WIDTH-1:0] yi0, yi1, yi2, yi3;

    always @(*) begin
        // Load inputs into arrays for easy indexing
        xr[0]=xr_in0;  xr[1]=xr_in1;  xr[2]=xr_in2;  xr[3]=xr_in3;
        xr[4]=xr_in4;  xr[5]=xr_in5;  xr[6]=xr_in6;  xr[7]=xr_in7;
        xr[8]=xr_in8;  xr[9]=xr_in9;  xr[10]=xr_in10; xr[11]=xr_in11;
        xr[12]=xr_in12;xr[13]=xr_in13;xr[14]=xr_in14;xr[15]=xr_in15;

        xi[0]=xi_in0;  xi[1]=xi_in1;  xi[2]=xi_in2;  xi[3]=xi_in3;
        xi[4]=xi_in4;  xi[5]=xi_in5;  xi[6]=xi_in6;  xi[7]=xi_in7;
        xi[8]=xi_in8;  xi[9]=xi_in9;  xi[10]=xi_in10; xi[11]=xi_in11;
        xi[12]=xi_in12;xi[13]=xi_in13;xi[14]=xi_in14;xi[15]=xi_in15;

        // Perform 4 Radix-4 butterflies
        for (g = 0; g < 4; g = g + 1) begin
            xr0 = xr[g];
            xr1 = xr[g + 4];
            xr2 = xr[g + 8];
            xr3 = xr[g + 12];

            xi0 = xi[g];
            xi1 = xi[g + 4];
            xi2 = xi[g + 8];
            xi3 = xi[g + 12];

            // Butterfly equations
            yr0 = xr0 + xr1 + xr2 + xr3;
            yi0 = xi0 + xi1 + xi2 + xi3;

            yr1 = xr0 - xr2 + xi1 - xi3;
            yi1 = xi0 - xi2 - xr1 + xr3;

            yr2 = xr0 - xr1 + xr2 - xr3;
            yi2 = xi0 - xi1 + xi2 - xi3;

            yr3 = xr0 - xr2 - xi1 + xi3;
            yi3 = xi0 - xi2 + xr1 - xr3;

            yr[g*4 + 0] = yr0;  yi[g*4 + 0] = yi0;
            yr[g*4 + 1] = yr1;  yi[g*4 + 1] = yi1;
            yr[g*4 + 2] = yr2;  yi[g*4 + 2] = yi2;
            yr[g*4 + 3] = yr3;  yi[g*4 + 3] = yi3;
        end

        // Assign to outputs (flattened)
        { yr_out0,  yr_out1,  yr_out2,  yr_out3,
          yr_out4,  yr_out5,  yr_out6,  yr_out7,
          yr_out8,  yr_out9,  yr_out10, yr_out11,
          yr_out12, yr_out13, yr_out14, yr_out15 } =
          { yr[0], yr[1], yr[2], yr[3],
            yr[4], yr[5], yr[6], yr[7],
            yr[8], yr[9], yr[10], yr[11],
            yr[12], yr[13], yr[14], yr[15] };

        { yi_out0,  yi_out1,  yi_out2,  yi_out3,
          yi_out4,  yi_out5,  yi_out6,  yi_out7,
          yi_out8,  yi_out9,  yi_out10, yi_out11,
          yi_out12, yi_out13, yi_out14, yi_out15 } =
          { yi[0], yi[1], yi[2], yi[3],
            yi[4], yi[5], yi[6], yi[7],
            yi[8], yi[9], yi[10], yi[11],
            yi[12], yi[13], yi[14], yi[15] };
    end
endmodule

