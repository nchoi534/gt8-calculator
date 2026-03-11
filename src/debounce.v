module debounce (
    input wire clk,
    input wire btn_in,
    output reg btn_out,
    output reg btn_pressed
);
    reg [19:0] counter;
    reg btn_prev;

    always @(posedge clk) begin
        if (btn_in != btn_prev) begin
            counter  <= 0;
            btn_prev <= btn_in;
        end else if (counter < 1000000) begin
            counter <= counter + 1;
        end else begin
            btn_out <= btn_in;
        end
    end

    // Hold btn_pressed HIGH as long as button is held down and stable
    always @(posedge clk) begin
        if (counter == 1000000 && btn_in == 1'b1)
            btn_pressed <= 1'b1;
        else
            btn_pressed <= 1'b0;
    end

endmodule