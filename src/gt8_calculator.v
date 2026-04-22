module gt8_calculator (
    input wire MAX10_CLK1_50,
    input wire [9:0] SW,
    input wire [1:0] KEY,
    output wire [9:0] LEDR,
    output wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);

    wire [7:0] A, B;
    wire [2:0] opcode, fsm_ledr, state_out;
    wire [7:0] result;
    wire carry, overflow, zero;
    wire [3:0] hundreds, tens, ones;

    wire key0_clean, key1_clean;

    debounce db0 (
        .clk        (MAX10_CLK1_50),
        .reset      (SW[9]),
        .btn_in     (~KEY[0]),
        .btn_out    (key0_clean),
        .btn_pressed()
    );

    debounce db1 (
        .clk        (MAX10_CLK1_50),
        .reset      (SW[9]),
        .btn_in     (~KEY[1]),
        .btn_out    (key1_clean),
        .btn_pressed()
    );

    fsm calculator_fsm (
        .clk          (MAX10_CLK1_50),
        .key0_pressed (key0_clean),
        .key1_pressed (key1_clean),
        .SW           (SW[7:0]),
        .A(A), .B(B), .opcode(opcode), .LEDR(fsm_ledr),
        .state_out    (state_out),
        .reset        (SW[9])
    );

    alu alu0 (
        .A(A), .B(B), .opcode(opcode), .result(result),
        .carry(carry), .overflow(overflow), .zero(zero)
    );

    doubleDabber bcd0 (
        .binary(result), .hundreds(hundreds),
        .tens(tens), .ones(ones)
    );

    seg_7driver hex0 (.digit(ones),     .segments(HEX0));
    seg_7driver hex1 (.digit(tens),     .segments(HEX1));
    seg_7driver hex2 (.digit(hundreds), .segments(HEX2));

    assign LEDR[2:0] = state_out;
    assign LEDR[3]   = carry;
    assign LEDR[4]   = overflow;
    assign LEDR[5]   = zero;
    assign LEDR[9:6] = 4'b0000;
    assign HEX3 = 7'b1111111;
    assign HEX4 = 7'b1111111;
    assign HEX5 = 7'b1111111;

endmodule