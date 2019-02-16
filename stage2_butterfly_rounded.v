module stage2_butterfly_rounded
#(
    parameter INW  = 16,
    parameter OUTW = 48
)
(
    input  wire signed [16*INW-1:0] xr_in_flat,
    input  wire signed [16*INW-1:0] xi_in_flat,
    output wire signed [16*OUTW-1:0] yr_out_flat,
    output wire signed [16*OUTW-1:0] yi_out_flat
);

    reg signed [INW-1:0]  xr [0:15];
    reg signed [INW-1:0]  xi [0:15];
    reg signed [OUTW-1:0] yr [0:15];
    reg signed [OUTW-1:0] yi [0:15];

    reg signed [15:0] wr [0:15];
    reg signed [15:0] wi [0:15];

    integer k, q, src_idx, tw_idx;
    reg signed [31:0] xr_t, xi_t, wr_t, wi_t;
    reg signed [47:0] prod_r, prod_i;
    reg signed [47:0] acc_r, acc_i;

    initial begin
        wr[0]=32767;  wi[0]=0;
        wr[1]=30274;  wi[1]=-12539;
        wr[2]=23170;  wi[2]=-23170;
        wr[3]=12539;  wi[3]=-30274;
        wr[4]=0;      wi[4]=-32767;
        wr[5]=-12539; wi[5]=-30274;
        wr[6]=-23170; wi[6]=-23170;
        wr[7]=-30274; wi[7]=-12539;
        wr[8]=-32767; wi[8]=0;
        wr[9]=-30274; wi[9]=12539;
        wr[10]=-23170;wi[10]=23170;
        wr[11]=-12539;wi[11]=30274;
        wr[12]=0;     wi[12]=32767;
        wr[13]=12539; wi[13]=30274;
        wr[14]=23170; wi[14]=23170;
        wr[15]=30274; wi[15]=12539;
    end

    always @(*) begin
        for (k=0; k<16; k=k+1) begin
            xr[k] = xr_in_flat[k*INW +: INW];
            xi[k] = xi_in_flat[k*INW +: INW];
        end

        for (k=0; k<16; k=k+1) begin
            acc_r = 0; acc_i = 0;
            for (q=0; q<4; q=q+1) begin
                src_idx = q*4 + (k % 4);
                tw_idx  = (k * q) % 16;
                xr_t = xr[src_idx];
                xi_t = xi[src_idx];
                wr_t = wr[tw_idx];
                wi_t = wi[tw_idx];
                prod_r = xr_t*wr_t - xi_t*wi_t;
                prod_i = xr_t*wi_t + xi_t*wr_t;
                acc_r = acc_r + prod_r;
                acc_i = acc_i + prod_i;
            end
            yr[k] = acc_r;
            yi[k] = acc_i;
        end
    end

    genvar g;
    generate
        for (g=0; g<16; g=g+1) begin: pack
            assign yr_out_flat[g*OUTW +: OUTW] = yr[g];
            assign yi_out_flat[g*OUTW +: OUTW] = yi[g];
        end
    endgenerate
endmodule

