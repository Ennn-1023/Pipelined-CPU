module TotalALU(clk, rst, Signal, ALUop, dataA, dataB, Output);
  input clk, rst;
  input[5:0] Signal;
  input[1:0] ALUop;
  input[31:0] dataA, dataB;
  output[31:0] Output;
  
  // define signal
  parameter AND = 6'b100100; // d36
  parameter OR  = 6'b100101; // d37
  parameter ADD = 6'b100000; // d32
  parameter SUB = 6'b100010; // d34
  parameter SLT = 6'b101010; // d42
  parameter SLL = 6'b000000; // d0
  parameter MULTU = 6'b011001;// d25
  
  parameter Hi = 6'd16;
  parameter Lo = 6'd18;
  
  wire[5:0] SignaltoMUX;
  wire SignaltoSHT, SignaltoMULTU;
  wire[2:0] SignaltoALU;
  wire[31:0] ALUOut, HiOut, LoOut, SHTOut;
  wire[31:0] dataOut;
  wire[63:0] MulAns;
  
  ALUControl ALUControl(.clk(clk), .ALUop(ALUop), .Signal(Signal), .SignaltoALU(SignaltoALU), .SignaltoSHT(SignaltoSHT), 
                        .SignaltoMUX(SignaltoMUX), .SignaltoMULTU(SignaltoMULTU));
  ALU ALU(.control(SignaltoALU), .A(dataA), .B(dataB), .dataOut(ALUOut), .reset(rst));
  MULTU mult(.clk(clk), .reset(rst), .dataA(dataA), .dataB(dataB), .SignaltoMULTU(SignaltoMULTU), .dataOut(MulAns));
  HiLo HiLo(.clk(clk), .Signal(Signal), .multAns(MulAns), .HiOut(HiOut), .LoOut(LoOut), .reset(rst));
  shifter sht(.dataIn(dataA), .amount(dataB[4:0]), .select(SignaltoSHT), .dataOut(SHTOut));
  MUX mux(.sel(SignaltoMUX), .ALUOut(ALUOut), .HiOut(HiOut), .LoOut(LoOut), .SHTOut(SHTOut), .Output(Output));
  
endmodule