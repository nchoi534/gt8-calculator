module doubleDabber (
    input wire [7:0] binary,
    output reg [3:0] hundreds,
    output reg [3:0] tens,
    output reg [3:0] ones
);
    reg [19:0] shift;
    integer i;
    always @(*) begin
        // Step 1: Load binary into the lower 8 bits, clear BCD columns
        shift = {12'b0, binary};

        // Step 2: Loop 8 times
        for (i = 0; i < 8; i = i + 1) begin
            if (shift [11:8] >= 4'b0101) begin
                shift [11:8] = shift [11:8] + 3;
            end
            if (shift [15:12] >= 4'b0101) begin
                shift [15:12] = shift [15:12] + 3;
            end
            if (shift [19:16] >= 4'b0101) begin
                shift [19:16] = shift [19:16] + 3;
            end
            shift = shift << 1;
        end

        // Step 3: Extract results
        hundreds = shift[19:16];
        tens     = shift[15:12];
        ones     = shift[11:8];
    end 
endmodule