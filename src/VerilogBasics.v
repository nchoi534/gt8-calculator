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