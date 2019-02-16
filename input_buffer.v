module input_buffer #(
    parameter N = 16,
    parameter WIDTH = 16
)(
    input  wire clk,
    input  wire rst,
    input  wire load,
    input  wire [3:0] addr_in,
    input  wire signed [WIDTH-1:0] xr_in,

    output wire signed [WIDTH-1:0] xr_out0,
    output wire signed [WIDTH-1:0] xi_out0,

    output wire signed [N*WIDTH-1:0] xr_flat,
    output wire signed [N*WIDTH-1:0] xi_flat
);

    reg signed [WIDTH-1:0] xr_mem [0:N-1];
    reg signed [WIDTH-1:0] xi_mem [0:N-1];

    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < N; i = i + 1) begin
                xr_mem[i] <= 0;
                xi_mem[i] <= 0;
            end
        end else if (load) begin
            xr_mem[addr_in] <= xr_in;
            xi_mem[addr_in] <= 0;
        end
    end
   
    assign xr_out0 = xr_mem[0];
    assign xi_out0 = xi_mem[0];
    
    genvar k;
    generate
        for (k = 0; k < N; k = k + 1) begin : FLATTEN
            assign xr_flat[k*WIDTH +: WIDTH] = xr_mem[k];
            assign xi_flat[k*WIDTH +: WIDTH] = xi_mem[k];
        end
    endgenerate
endmodule

