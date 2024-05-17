module MULTU (
    input clk,
    input reset,
    input [31:0] dataA,     // Multiplicand
    input [31:0] dataB,     // Multiplier
    input SignaltoMULTU,    // Start signal
    output reg [63:0] dataOut, // Product of the multiplication
    output reg done          // Indicates when the operation is complete
);
    reg [31:0] multiplicand;
    reg [31:0] multiplier;
    reg [5:0] count;        // 32 bits, but we use 6 bits to count to 32

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            dataOut <= 64'd0;
            done <= 0;
            count <= 0;
            multiplicand <= 0;
            multiplier <= 0;
        end
        else if (SignaltoMULTU && !done) begin
            if (count == 0) begin
                multiplicand <= dataA;
                multiplier <= dataB;
                dataOut <= 0;     // Clear the output register
            end
            
            // Perform multiplication step-by-step
            if (multiplier[0] == 1) begin
                dataOut[63:32] <= multiplicand+dataOut[63:32];
            end
            
            // Prepare for the next step
            multiplier <= multiplier >> 1;
            dataOut <= dataOut >> 1;
            count <= count + 1;
            // Check if multiplication is done
            if (count == 32) begin
                done <= 1;
                count <= 0;  // Reset the count for potential new operation
            end
        end
    end
endmodule
