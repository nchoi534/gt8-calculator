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
        if (sel == 0)
            out = A;
        else
            out = B; 
    end
endmodule