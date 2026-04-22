module debounce (
    input wire clk,
    input wire reset,
    input wire btn_in,
    output reg btn_out,
    output reg btn_pressed
);
    reg [20:0] counter;
    reg btn_sync0, btn_sync1, btn_last;

    always @(posedge clk) begin
        if (~reset) begin
            counter   <= 0;
            btn_sync0 <= 0;
            btn_sync1 <= 0;
            btn_last  <= 0;
            btn_out   <= 0;
            btn_pressed <= 0;
        end else begin
            btn_sync0 <= btn_in;
            btn_sync1 <= btn_sync0;

            if (btn_sync1 == btn_last) begin
                if (counter < 21'd1000000)
                    counter <= counter + 1;
                else
                    btn_out <= btn_last;
            end else begin
                counter  <= 0;
                btn_last <= btn_sync1;
            end

            btn_pressed <= (btn_sync1 == 1'b1 && counter == 21'd999999);
        end
    end

endmodule