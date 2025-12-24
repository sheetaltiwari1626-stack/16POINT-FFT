module twiddle_factor #(parameter WIDTH = 16)(
    input  wire [3:0] addr,   // Twiddle index (0-15)
    output reg  signed [WIDTH-1:0] wr, // Real part (cos)
    output reg  signed [WIDTH-1:0] wi  // Imag part (-sin)
);
    always @(*) begin
        case (addr)
            4'd0:  begin wr = 16'sd32767;  wi = 16'sd0;      end  // 1 + j0
            4'd1:  begin wr = 16'sd30274;  wi = -16'sd12539; end  // cos22.5
            4'd2:  begin wr = 16'sd23170;  wi = -16'sd23170; end  // cos45
            4'd3:  begin wr = 16'sd12539;  wi = -16'sd30274; end  // cos67.5
            4'd4:  begin wr = 16'sd0;      wi = -16'sd32767; end  // cos90
            4'd5:  begin wr = -16'sd12539; wi = -16'sd30274; end
            4'd6:  begin wr = -16'sd23170; wi = -16'sd23170; end
            4'd7:  begin wr = -16'sd30274; wi = -16'sd12539; end
            4'd8:  begin wr = -16'sd32767; wi = 16'sd0;      end
            4'd9:  begin wr = -16'sd30274; wi = 16'sd12539;  end
            4'd10: begin wr = -16'sd23170; wi = 16'sd23170;  end
            4'd11: begin wr = -16'sd12539; wi = 16'sd30274;  end
            4'd12: begin wr = 16'sd0;      wi = 16'sd32767;  end
            4'd13: begin wr = 16'sd12539;  wi = 16'sd30274;  end
            4'd14: begin wr = 16'sd23170;  wi = 16'sd23170;  end
            4'd15: begin wr = 16'sd30274;  wi = 16'sd12539;  end
            default: begin wr = 16'sd0; wi = 16'sd0; end
        endcase
    end
endmodule

