module alu (
    // your ports go here
    input wire [7:0] A,
    input wire [7:0] B,
    input wire [2:0] opcode,
    output reg [7:0] result,
    output reg carry,
    output reg overflow,
    output reg zero
);
    reg [8:0] temp;
    always @(*) begin
        case(opcode) 
            3'b0: begin
                carry = 1'b0;
                overflow = 1'b0;
                temp = {1'b0, A} + {1'b0, B};
                result = temp[7:0];
                carry = temp[8];
                overflow = ((~A[7] & ~B[7] & result[7]) | (A[7] & B[7] & ~result[7]));
                zero = (result == 8'b0) ? 1 : 0;
            end
            3'b001: begin
                carry = 1'b0;
                overflow = 1'b0;
                temp = {1'b0, A} + {1'b0, ~B + 1};
                result = temp[7:0];
                carry = temp[8];
                overflow = (~A[7] & B[7] & result[7]) | (A[7] & ~B[7] & ~result[7]);
                zero = (result == 8'b0) ? 1 : 0;
            end
            default: result = 0;
        endcase
    end
endmodule // alu