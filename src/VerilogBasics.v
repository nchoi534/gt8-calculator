module and_gate (
    input wire A, 
    input wire B, 
    output wire Z
);

    assign Z = A & B;
endmodule

module xor_gate (
    input wire A, 
    input wire B, 
    output wire Z
);

    assign Z = (~A & B) | (~B & A); // Can also be written as A ^ B
endmodule

module and_8bitgate (
    input wire [7:0] A, 
    input wire [7:0] B, 
    output wire [7:0] Z
);

    assign Z = A & B;
endmodule 

module or_8bitgate (
    input wire [7:0] A, 
    input wire [7:0] B, 
    output wire [7:0] Z
);
    assign Z = A | B;
endmodule 

module mux_2to1 (
    input wire sel,
    input wire [7:0] A,
    input wire [7:0] B,
    output reg [7:0] out
);
    always @(*) begin
        case (sel)
            1'b0: out = A;
            1'b1: out = B;
            default: out = 0;
        endcase
    end
endmodule

module half_adder (
    input wire A,
    input wire B,
    output wire sum,
    output wire carry
);
    assign sum = A ^ B; 
    assign carry = A & B;
endmodule

module full_adder (
    input wire A,
    input wire B,
    input wire carryin,
    output wire sum,
    output wire carryout
);
    assign sum = A ^ B ^ carryin;
    assign carryout = (A & B) | (A & carryin) | (B & carryin);
endmodule

module adder_8bit (
    input wire [7:0] A,
    input wire [7:0] B,
    output reg [7:0] sum,
    output reg carryout, 
);
    reg [8:0] temp; //temp variable that holds the 9-bit result

    always @(*) begin
        temp = {1'b0, A} + {1'b0, B};
        sum = temp[7:0]; //assign the lower 8 bits to sum
        carryout = temp[8]; //assign the 9th bit to carryout
    end

endmodule

module flags (
    input wire [7:0] A,
    input wire [7:0] B,
    input wire [7:0] sum,
    input wire carry_in,
    output reg zero,
    output reg carry,
    output reg overflow
);

    always @(*) begin
        zero = (sum == 8'b0) ? 1 : 0;
        carry = carry_in;
        overflow = ((~A[7] & ~B[7] & sum[7]) | (A[7] & B[7] & ~sum[7]));
    end
endmodule