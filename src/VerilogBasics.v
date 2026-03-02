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