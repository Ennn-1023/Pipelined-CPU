module MULTU (
    input clk,
    input reset,
    input [31:0] dataA,     // Multiplicand
    input [31:0] dataB,     // Multiplier
    input SignaltoMULTU,    // Start signal
    output [63:0] dataOut // Product of the multiplication
);

    reg [31:0] multiplicand;
    reg [31:0] multiplier;
    reg [63:0] product;
    wire[63:0] temp;
    reg[5:0] count;
    assign temp = (multiplier[0] == 1)?({multiplicand, 32'b0} + product) : product;
    assign dataOut = product;
    
    // assign the input value into register when start
    always @(posedge SignaltoMULTU) begin
      multiplicand <= dataA;
      multiplier <= dataB;
      product <= 0;
      count <= 0;
    end
    
    always @(posedge clk or reset) begin
        if (reset) begin
            multiplicand <= 0;
            multiplier <= 0;
            product <= 0;
            count <= 0;
        end
        else begin
          if (SignaltoMULTU) begin   
              // Prepare for the next step
              if (count > 0 && count < 33) begin
                // $display( "In count>0 : multiplier = %d, product = %d", multiplier, product);
                product <= temp >> 1;
                multiplier = @(negedge clk)multiplier >> 1;
              end
              
              count <= count+1;
          end // end of if
        end // end of else
    end // end of always
endmodule