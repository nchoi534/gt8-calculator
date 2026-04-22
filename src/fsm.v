module fsm (
    input wire clk,
    input wire key0_pressed,
    input wire key1_pressed,
    input wire [7:0] SW,
    input wire reset,
    output reg [7:0] A,
    output reg [7:0] B,
    output reg [2:0] opcode,
    output reg [2:0] LEDR,
    output wire [2:0] state_out
);
    parameter IDLE        = 3'b000;
    parameter LOAD_A      = 3'b001;
    parameter LOAD_B      = 3'b010;
    parameter SELECT_OP   = 3'b011;
    parameter COMPUTE     = 3'b100;
    parameter SHOW_RESULT = 3'b101;

    (* preserve *) reg [2:0] state;
    reg key0_prev;
    reg key1_prev;
    wire key0_pulse = key0_pressed & ~key0_prev;
    wire key1_pulse = key1_pressed & ~key1_prev;

    always @(posedge clk) begin
        if (~reset) begin
            state     <= IDLE;
            key0_prev <= 0;
            key1_prev <= 0;
            opcode    <= 3'd0;
            LEDR      <= 3'b000;
            A         <= 8'd0;
            B         <= 8'd0;
        end else begin
            key0_prev <= key0_pressed;
            key1_prev <= key1_pressed;
            case(state)
                IDLE: begin
                    LEDR <= 3'b000;
                    if (key0_pulse) state <= LOAD_A;
                end
                LOAD_A: begin
                    A <= SW;
                    if (key0_pulse) state <= LOAD_B;
                end
                LOAD_B: begin
                    B <= SW;
                    if (key1_pulse) state <= SELECT_OP;
                end
                SELECT_OP: begin
                    opcode <= SW[2:0];        // continuously reads switches
                    LEDR   <= SW[2:0];        // preview opcode on LEDs
                    if (key1_pulse) state <= COMPUTE;
                end
                COMPUTE: begin
                    state <= SHOW_RESULT;
                end
                SHOW_RESULT: begin
                    LEDR <= opcode;
                    if (key0_pulse) state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end

    assign state_out = state;
endmodule