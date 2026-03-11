module gt8_calculator (
    input wire CLOCK_50,      // 50MHz onboard clock
    input wire [9:0] SW,      // slide switches
    input wire [1:0] KEY,     // pushbuttons (active LOW)
    output wire [9:0] LEDR,   // red LEDs
    output wire [6:0] HEX0,   // 7-segment displays
    output wire [6:0] HEX1,
    output wire [6:0] HEX2,
    output wire [6:0] HEX3,
    output wire [6:0] HEX4,
    output wire [6:0] HEX5
);

    // Debounced button signals
    //Debounce bypassed for testing

    // FSM outputs
    wire [7:0] A, B;
    wire [2:0] opcode;
    wire [2:0] fsm_ledr;

    // ALU outputs
    wire [7:0] result;
    wire carry, overflow, zero;

    // BCD outputs
    wire [3:0] hundreds, tens, ones;    

    // Debounce KEY[0] and KEY[1] (invert because active LOW)
    /*debounce db0 (
        .clk        (CLOCK_50),
        .btn_in     (~KEY[0]),
        .btn_out    (key0_clean),
        .btn_pressed(key0_pressed)
    );

    debounce db1 (
        .clk (CLOCK_50),
        .btn_in (~KEY[1]),
        .btn_out (key1_clean),
        .btn_pressed (key1_pressed)
    );
    */
    // fsm KEY[0] and KEY [1]
    fsm calculator_fsm (
        .clk(CLOCK_50),
        .key0_pressed(~KEY[0]),
        .key1_pressed(~KEY[1]),
        .SW(SW[7:0]),
        .A(A),
        .B(B),
        .opcode(opcode),
        .LEDR(fsm_ledr),
        .state_out()
    );

    // alu 
    alu alu0 (
        .A (A),
        .B (B),
        .opcode (opcode),
        .result (result),
        .carry (carry),
        .overflow (overflow),
        .zero (zero)
    );

    // doubleDabber
    doubleDabber bcd0 (
        .binary(result),
        .hundreds(hundreds),
        .tens(tens),
        .ones(ones)
    );

    // Seg7 Driver HEX 0, HEX 1, HEX 2
    seg_7driver hex0 (
        .digit (ones),
        .segments (HEX0)
    );

    seg_7driver hex1 (
        .digit (tens),
        .segments (HEX1)
    );

    seg_7driver hex2 (
        .digit (hundreds),
        .segments (HEX2)
    );

    assign LEDR[2:0] = fsm_ledr;
    assign LEDR[3]   = carry;
    assign LEDR[4]   = overflow;
    assign LEDR[5]   = zero;
    assign LEDR[9:6] = 4'b0000;
    assign HEX3      = 7'b1111111; // blank
    assign HEX4      = 7'b1111111; // blank
    assign HEX5      = 7'b1111111; // blank

endmodule