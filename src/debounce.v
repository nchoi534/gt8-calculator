module debounce (
    input wire clk,
    input wire btn_in,
    output reg btn_out
    output wire btn_pressed;
); 
    reg [19:0] counter;
    reg btn_prev;
    reg btn_prev_clean;
    

    always @(posedge clk) begin
        if (btn_in != btn_prev) begin
            // signal changed — reset counter           
            counter <= 0;
            btn_prev <= btn_in;
        end else if (counter < 1000000) begin
            // signal stable — keep counting
            counter <= counter + 1;
        end else begin 
            // counter reached threshold — signal is clean
            btn_out <= btn_in;
        end
    end

    always @(posedge clk) begin
        btn_prev_clean <= btn_out;
    end

    // btn_pressed is HIGH for exactly one clock cycle on press
    assign btn_pressed = btn_out & ~btn_prev_clean;

endmodule