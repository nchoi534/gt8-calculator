module alu_tb;

    reg [7:0] A, B;
    reg [2:0] opcode;
    wire [7:0] result;
    wire carry, overflow, zero;

    integer pass_count;
    integer fail_count;

    alu uut (
        .A(A), .B(B), .opcode(opcode),
        .result(result), .carry(carry),
        .overflow(overflow), .zero(zero)
    );

    task check;
        input [7:0]   expected_result;
        input         expected_carry;
        input         expected_overflow;
        input         expected_zero;
        input [8*20:1] test_name;
        begin
            #10;
            if (result !== expected_result ||
                carry    !== expected_carry ||
                overflow !== expected_overflow ||
                zero     !== expected_zero) begin
                $display("FAIL | %-20s | got result=%3d carry=%b overflow=%b zero=%b | expected result=%3d carry=%b overflow=%b zero=%b",
                    test_name,
                    result, carry, overflow, zero,
                    expected_result, expected_carry, expected_overflow, expected_zero);
                fail_count = fail_count + 1;
            end else begin
                $display("PASS | %-20s | result=%3d carry=%b overflow=%b zero=%b",
                    test_name, result, carry, overflow, zero);
                pass_count = pass_count + 1;
            end
        end
    endtask

    initial begin
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("           ALU Testbench                ");
        $display("========================================");

        // ADD
        $display("--- ADD ---");
        A = 8'd0;   B = 8'd0;   opcode = 3'b000; check(8'd0,   0, 0, 1, "ADD 0+0");
        A = 8'd5;   B = 8'd3;   opcode = 3'b000; check(8'd8,   0, 0, 0, "ADD 5+3");
        A = 8'd255; B = 8'd1;   opcode = 3'b000; check(8'd0,   1, 0, 1, "ADD 255+1 carry");
        A = 8'd127; B = 8'd1;   opcode = 3'b000; check(8'd128, 0, 1, 0, "ADD 127+1 overflow");

        // SUB
        $display("--- SUB ---");
        A = 8'd10; B = 8'd5;  opcode = 3'b001; check(8'd5,   0, 0, 0, "SUB 10-5");
        A = 8'd5;  B = 8'd5;  opcode = 3'b001; check(8'd0,   0, 0, 1, "SUB 5-5 zero");
        A = 8'd5;  B = 8'd10; opcode = 3'b001; check(8'd251, 1, 0, 0, "SUB 5-10 borrow");

        // AND
        $display("--- AND ---");
        A = 8'b11001100; B = 8'b10101010; opcode = 3'b010; check(8'b10001000, 0, 0, 0, "AND CC&AA");
        A = 8'd0;        B = 8'd255;      opcode = 3'b010; check(8'd0,        0, 0, 1, "AND 0&255 zero");

        // OR
        $display("--- OR  ---");
        A = 8'b11001100; B = 8'b10101010; opcode = 3'b011; check(8'b11101110, 0, 0, 0, "OR  CC|AA");
        A = 8'd0;        B = 8'd0;        opcode = 3'b011; check(8'd0,        0, 0, 1, "OR  0|0 zero");

        // XOR
        $display("--- XOR ---");
        A = 8'b11001100; B = 8'b10101010; opcode = 3'b100; check(8'b01100110, 0, 0, 0, "XOR CC^AA");
        A = 8'd255;      B = 8'd255;      opcode = 3'b100; check(8'd0,        0, 0, 1, "XOR 255^255 zero");

        // NOT
        $display("--- NOT ---");
        A = 8'b00000000; B = 8'd0; opcode = 3'b101; check(8'b11111111, 0, 0, 0, "NOT 0");
        A = 8'b11111111; B = 8'd0; opcode = 3'b101; check(8'b00000000, 0, 0, 1, "NOT 255 zero");

        $display("========================================");
        $display("  PASSED: %0d / %0d", pass_count, pass_count + fail_count);
        $display("  FAILED: %0d / %0d", fail_count, pass_count + fail_count);
        $display("========================================");
        $finish;
    end

endmodule