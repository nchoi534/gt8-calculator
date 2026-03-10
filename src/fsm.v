module fsm (
    input wire clk,
    input wire key0_pressed,
    input wire key1_pressed,
    input wire [7:0] SW,
    output reg [7:0] A,
    output reg [7:0] B,
    output reg [2:0] opcode,
    output reg [2:0] LEDR,
    output wire [2:0] state_out
);
    parameter IDLE        = 3'b000;
    parameter LOAD_A      = 3'b001;
    parameter SELECT_OP   = 3'b010;
    parameter LOAD_B      = 3'b011;
    parameter COMPUTE     = 3'b100;
    parameter SHOW_RESULT = 3'b101;

    reg [2:0] state;

    always @(posedge clk) begin 
        case(state) 
            IDLE: begin 
                // waiting for user — reset everything
                LEDR <= 3'b000;
                if (key0_pressed)
                    state <= LOAD_A;
            end
            LOAD_A: begin 
                A <= SW;
                state <= SELECT_OP;
            end
            SELECT_OP: begin 
                LEDR <= opcode;
                if (key0_pressed) begin
                    if (opcode == 3'd5)
                        opcode <= 3'd0;
                    else
                        opcode <= opcode + 1;
                end
                if (key1_pressed) begin
                    state <= LOAD_B;
                end
            end
            LOAD_B: begin 
                B <= SW;
                state <= COMPUTE;
            end
            COMPUTE: begin 
                state <= SHOW_RESULT;
            end
            SHOW_RESULT: begin 
                if (key0_pressed) begin
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
        endcase
    end

    assign state_out = state;
endmodule