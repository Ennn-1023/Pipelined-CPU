module MULTU(clk, reset, dataA, dataB, Signal, dataOut);
  input clk, reset;
  input Signal;
  input[31:0] dataA, dataB;
  output[63:0] dataOut;
  
  reg[31:0] A, B;
  reg[63:0] temp;
  
  always@(posedge clk or reset) begin
    if (reset)
      temp= 64'b0;
    else begin
      if (Signal) begin
        if (B[0])
          temp = {A, temp[31:0]};
        temp = {1'b0, temp};
        B = B >> 1;
      end
    end
  end
  
  assign dataOut = temp;
endmodule