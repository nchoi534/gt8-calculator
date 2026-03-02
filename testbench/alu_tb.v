module alu_tb;

    reg [7:0] A, B;
    reg [2:0] opcode;
    wire [7:0] result;
    wire carry, overflow, zero;

    alu uut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result),
        .carry(carry),
        .overflow(overflow),
        .zero(zero)
    );

    initial begin
        // Zero test
        A = 8'd0; B = 8'd0; opcode = 3'b000;  // set inputs
        #10;  // wait 10 time units for signals to settle
        $display("ADD 0+0: result=%d, zero=%b, carry=%b, overflow=%b", result, zero, carry, overflow);

        // Maximum test
        A = 8'd255; B = 8'd1; opcode = 3'b000;  // set inputs
        #10;  // wait 10 time units for signals to settle
        $display("ADD 255 + 1: result=%d, zero=%b, carry=%b, overflow=%b", result, zero, carry, overflow);

        // Signed Overflow
        A = 8'd127; B = 8'd1; opcode = 3'b000;  // set inputs
        #10;  // wait 10 time units for signals to settle
        $display("ADD 127 + 1: result=%d, zero=%b, carry=%b, overflow=%b", result, zero, carry, overflow);

        // Subtraction
        A = 8'd10; B = 8'd5; opcode = 3'b001;  // set inputs
        #10;  // wait 10 time units for signals to settle
        $display("SUB 10 - 5: result=%d, zero=%b, carry=%b, overflow=%b", result, zero, carry, overflow);

        // Subtraction 2
        A = 8'd5; B = 8'd10; opcode = 3'b001;  // set inputs
        #10;  // wait 10 time units for signals to settle
        $display("Sub 5 - 10: result=%d, zero=%b, carry=%b, overflow=%b", result, zero, carry, overflow);

        $finish;
    end

endmodule