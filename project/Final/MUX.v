module MUX(sel , ALUOut, HiOut, LoOut, SHTOut, Output);
  input[1:0] sel;
  input[31:0] ALUOut, HiOut, LoOut, SHTOut;
  output[31:0] Output;
    // define signal
  wire[31:0] Output;
  
  assign Output = (sel == 2'b11)? SHTOut:
                  (sel == 2'b01)? HiOut:
                  (sel == 2'b10)? LoOut:
                  ALUOut; // 00
endmodule