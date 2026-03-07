module seg_7driver (
    input wire [3:0] digit,
    output reg [6:0] segments
); 
    always @(*) begin 
        case (digit) 
        4'b0000: segments = 7'b1000000;
        4'b0001: segments = 7'b1111001;
        4'b0010: segments = 7'b0100100;
        4'b0011: segments = 7'b0110000;
        4'b0100: segments = 7'b0011001;
        4'b0101: segments = 7'b0010010;
        4'b0110: segments = 7'b0000010;
        4'b0111: segments = 7'b1111000;
        4'b1000: segments = 7'b0000000;
        4'b1001: segments = 7'b0010000;
        default: segments = 7'b0000000;
        endcase
    end
    
endmodule