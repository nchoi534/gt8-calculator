module gt8_calculator (
    input wire MAX10_CLK1_50,
    input wire [9:0] SW,
    input wire [1:0] KEY,
    output wire [9:0] LEDR,
    output wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);

    wire [7:0] A, B;
    wire [2:0] opcode, state_out, display_mode;
    wire [7:0] result;
    wire carry, overflow, zero;
    wire [3:0] hundreds, tens, ones;
    wire key0_clean, key1_clean;

    // 7-seg encoding (common anode, active LOW)
    // Letters needed: A, d, S, u, b, n, O, r, X, t
    localparam SEG_A   = 7'b0001000; // A
    localparam SEG_D   = 7'b0100001; // d
    localparam SEG_S   = 7'b0010010; // S
    localparam SEG_U   = 7'b1000001; // u (lowercase)
    localparam SEG_B   = 7'b0000011; // b
    localparam SEG_N   = 7'b0101011; // n
    localparam SEG_O   = 7'b0000001; // O
    localparam SEG_R   = 7'b0101111; // r
    localparam SEG_X   = 7'b0001001; // X
    localparam SEG_T   = 7'b0000111; // t
    localparam SEG_BLK = 7'b1111111; // blank

    // Wires for each display source
    wire [6:0] sw_hex0, sw_hex1, sw_hex2;
    wire [6:0] result_hex0, result_hex1, result_hex2;
    wire [6:0] op_hex0, op_hex1, op_hex2;

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
        .A(A), .B(B), .opcode(opcode),
        .display_mode (display_mode),
        .state_out    (state_out),
        .reset        (SW[9])
    );

    alu alu0 (
        .A(A), .B(B), .opcode(opcode),
        .result(result), .carry(carry),
        .overflow(overflow), .zero(zero)
    );

    // BCD for SW real-time display
    wire [3:0] sw_hundreds, sw_tens, sw_ones;
    doubleDabber bcd_sw (
        .binary(SW[7:0]),
        .hundreds(sw_hundreds), .tens(sw_tens), .ones(sw_ones)
    );

    // BCD for result display
    wire [3:0] res_hundreds, res_tens, res_ones;
    doubleDabber bcd_result (
        .binary(result),
        .hundreds(res_hundreds), .tens(res_tens), .ones(res_ones)
    );

    // SW digit drivers
    seg_7driver sw_d0 (.digit(sw_ones),     .segments(sw_hex0));
    seg_7driver sw_d1 (.digit(sw_tens),     .segments(sw_hex1));
    seg_7driver sw_d2 (.digit(sw_hundreds), .segments(sw_hex2));

    // Result digit drivers
    seg_7driver res_d0 (.digit(res_ones),     .segments(result_hex0));
    seg_7driver res_d1 (.digit(res_tens),     .segments(result_hex1));
    seg_7driver res_d2 (.digit(res_hundreds), .segments(result_hex2));

    // Op name display
    // 000=ADD, 001=SUb, 010=And, 011= Or, 100=Xor, 101=not
    assign op_hex2 = (opcode == 3'd0) ? SEG_A :   // A
                     (opcode == 3'd1) ? SEG_S :   // S
                     (opcode == 3'd2) ? SEG_A :   // A
                     (opcode == 3'd3) ? SEG_BLK : // blank
                     (opcode == 3'd4) ? SEG_X :   // X
                     SEG_N;                        // n

    assign op_hex1 = (opcode == 3'd0) ? SEG_D :   // d
                     (opcode == 3'd1) ? SEG_U :   // u
                     (opcode == 3'd2) ? SEG_N :   // n
                     (opcode == 3'd3) ? SEG_O :   // O
                     (opcode == 3'd4) ? SEG_O :   // O
                     SEG_O;                        // O

    assign op_hex0 = (opcode == 3'd0) ? SEG_D :   // d
                     (opcode == 3'd1) ? SEG_B :   // b
                     (opcode == 3'd2) ? SEG_D :   // d
                     (opcode == 3'd3) ? SEG_R :   // r
                     (opcode == 3'd4) ? SEG_R :   // r
                     SEG_T;                        // t

    // MUX display based on display_mode
    // 000=blank, 001=SW value, 010=op name, 011=result
    assign HEX0 = (display_mode == 3'b001) ? sw_hex0 :
                  (display_mode == 3'b010) ? op_hex0 :
                  (display_mode == 3'b011) ? result_hex0 :
                  SEG_BLK;

    assign HEX1 = (display_mode == 3'b001) ? sw_hex1 :
                  (display_mode == 3'b010) ? op_hex1 :
                  (display_mode == 3'b011) ? result_hex1 :
                  SEG_BLK;

    assign HEX2 = (display_mode == 3'b001) ? sw_hex2 :
                  (display_mode == 3'b010) ? op_hex2 :
                  (display_mode == 3'b011) ? result_hex2 :
                  SEG_BLK;

    assign LEDR[2:0] = state_out;
    assign LEDR[3]   = carry;
    assign LEDR[4]   = overflow;
    assign LEDR[5]   = zero;
    assign LEDR[9:6] = 4'b0000;
    assign HEX3 = SEG_BLK;
    assign HEX4 = SEG_BLK;
    assign HEX5 = SEG_BLK;

endmodule