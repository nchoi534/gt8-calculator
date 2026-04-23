module fsm (
    input wire clk,
    input wire key0_pressed,
    input wire key1_pressed,
    input wire [7:0] SW,
    input wire reset,
    output reg [7:0] A,
    output reg [7:0] B,
    output reg [2:0] opcode,
    output reg [2:0] display_mode,
    output wire [2:0] state_out
);
    // display_mode encoding
    // 000 = blank
    // 001 = real-time SW value
    // 010 = op name
    // 011 = show result

    parameter IDLE        = 3'b000;
    parameter LOAD_A      = 3'b001;
    parameter LOAD_B      = 3'b010;
    parameter SELECT_OP   = 3'b011;
    parameter SHOW_RESULT = 3'b100;

    (* preserve *) reg [2:0] state;
    reg key0_prev, key1_prev;
    reg [7:0] sw_prev;
    reg sw_changed;

    wire key0_pulse = key0_pressed & ~key0_prev;
    wire key1_pulse = key1_pressed & ~key1_prev;

    always @(posedge clk) begin
        if (~reset) begin
            state        <= IDLE;
            key0_prev    <= 0;
            key1_prev    <= 0;
            sw_prev      <= 8'd0;
            sw_changed   <= 0;
            opcode       <= 3'd0;
            display_mode <= 3'b001;
            A            <= 8'd0;
            B            <= 8'd0;
        end else begin
            key0_prev  <= key0_pressed;
            key1_prev  <= key1_pressed;
            sw_changed <= (SW != sw_prev);
            sw_prev    <= SW;

            case(state)
                IDLE: begin
                    display_mode <= 3'b001; // show SW value
                    if (key0_pulse) begin
                        A     <= SW;
                        state <= LOAD_A;
                        display_mode <= 3'b000; // blank immediately
                    end
                end

                LOAD_A: begin
                    if (sw_changed) begin
                        display_mode <= 3'b001; // show SW value
                    end
                    if (key0_pulse) begin
                        B     <= SW;
                        state <= LOAD_B;
                        display_mode <= 3'b010; // show op name immediately
                    end
                end

                LOAD_B: begin
                    opcode       <= SW[2:0];
                    display_mode <= 3'b010; // show op name
                    if (key1_pulse) begin
                        state <= SELECT_OP;
                    end
                end

                SELECT_OP: begin
                    opcode <= SW[2:0];
                    state  <= SHOW_RESULT;
                end

                SHOW_RESULT: begin
                    display_mode <= 3'b011; // show result
                    if (key0_pulse) begin
                        state        <= IDLE;
                        display_mode <= 3'b001;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

    assign state_out = state;
endmodule