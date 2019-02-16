module stage1_buffer #(parameter WIDTH = 16)(
    input  wire signed [WIDTH-1:0] yr_in0, yr_in1, yr_in2, yr_in3,
    input  wire signed [WIDTH-1:0] yr_in4, yr_in5, yr_in6, yr_in7,
    input  wire signed [WIDTH-1:0] yr_in8, yr_in9, yr_in10, yr_in11,
    input  wire signed [WIDTH-1:0] yr_in12, yr_in13, yr_in14, yr_in15,

    input  wire signed [WIDTH-1:0] yi_in0, yi_in1, yi_in2, yi_in3,
    input  wire signed [WIDTH-1:0] yi_in4, yi_in5, yi_in6, yi_in7,
    input  wire signed [WIDTH-1:0] yi_in8, yi_in9, yi_in10, yi_in11,
    input  wire signed [WIDTH-1:0] yi_in12, yi_in13, yi_in14, yi_in15,

    output reg  signed [WIDTH-1:0] yr_out0, yr_out1, yr_out2, yr_out3,
    output reg  signed [WIDTH-1:0] yr_out4, yr_out5, yr_out6, yr_out7,
    output reg  signed [WIDTH-1:0] yr_out8, yr_out9, yr_out10, yr_out11,
    output reg  signed [WIDTH-1:0] yr_out12, yr_out13, yr_out14, yr_out15,

    output reg  signed [WIDTH-1:0] yi_out0, yi_out1, yi_out2, yi_out3,
    output reg  signed [WIDTH-1:0] yi_out4, yi_out5, yi_out6, yi_out7,
    output reg  signed [WIDTH-1:0] yi_out8, yi_out9, yi_out10, yi_out11,
    output reg  signed [WIDTH-1:0] yi_out12, yi_out13, yi_out14, yi_out15
);

    always @(*) begin
        // Simple storage and forwarding
        yr_out0 = yr_in0;  yr_out1 = yr_in1;  yr_out2 = yr_in2;  yr_out3 = yr_in3;
        yr_out4 = yr_in4;  yr_out5 = yr_in5;  yr_out6 = yr_in6;  yr_out7 = yr_in7;
        yr_out8 = yr_in8;  yr_out9 = yr_in9;  yr_out10 = yr_in10; yr_out11 = yr_in11;
        yr_out12 = yr_in12; yr_out13 = yr_in13; yr_out14 = yr_in14; yr_out15 = yr_in15;

        yi_out0 = yi_in0;  yi_out1 = yi_in1;  yi_out2 = yi_in2;  yi_out3 = yi_in3;
        yi_out4 = yi_in4;  yi_out5 = yi_in5;  yi_out6 = yi_in6;  yi_out7 = yi_in7;
        yi_out8 = yi_in8;  yi_out9 = yi_in9;  yi_out10 = yi_in10; yi_out11 = yi_in11;
        yi_out12 = yi_in12; yi_out13 = yi_in13; yi_out14 = yi_in14; yi_out15 = yi_in15;
    end

endmodule


