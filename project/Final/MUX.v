module MUX(sel , ALUOut, HiOut, LoOut, SHTOut, Output);
  input[5:0] sel;
  input[31:0] ALUOut, HiOut, LoOut, SHTOut;
  output[31:0] Output;
    // define signal

  parameter SLL = 6'b000000; // d0
  parameter Hi = 6'd16;
  parameter Lo = 6'd18;
  
  assign Output = (sel == SLL)? SHTOut:
                  (sel == Hi)? HiOut:
                  (sel == Lo)? LoOut:
                  ALUOut;
endmodule