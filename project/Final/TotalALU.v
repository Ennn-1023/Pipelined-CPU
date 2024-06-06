module TotalALU(clk, rst, operation, SignaltoMULTU, SignaltoSHT, SignaltoMUX,
                SignaltoHi, SignaltoLo,dataA, dataB, shamt, Output, Zero);
  input clk, rst;
  input[2:0] operation;
  input[1:0] SignaltoMUX;
  input SignaltoMULTU;
  input SignaltoSHT;
  input SignaltoHi;
  input SignaltoLo;
  input[31:0] dataA, dataB;
  input [4:0] shamt;
  output[31:0] Output;
  output Zero;
  // define signal
  parameter AND = 6'b100100; // d36
  parameter OR  = 6'b100101; // d37
  parameter ADD = 6'b100000; // d32
  parameter SUB = 6'b100010; // d34
  parameter SLT = 6'b101010; // d42
  parameter SLL = 6'b000000; // d0
  parameter MULTU = 6'b011001;// d25
  parameter JR  = 6'd8;
    
  parameter Hi = 6'd16;
  parameter Lo = 6'd18;
  
  wire Zero;
  wire[31:0] ALUOut, HiOut, LoOut, SHTOut;
  wire[31:0] dataOut;
  wire[63:0] MulAns;
  
  ALU ALU(.control(operation), .A(dataA), .B(dataB), .dataOut(ALUOut), .reset(rst), .Zero(Zero));
  MULTU mult(.clk(clk), .reset(rst), .dataA(dataA), .dataB(dataB), .SignaltoMULTU(SignaltoMULTU), .dataOut(MulAns));
  HiLo HiLo(.clk(clk), .Signal(funct), .multAns(MulAns), .HiOut(HiOut), .LoOut(LoOut), .reset(rst));
  // sll input : rt(dataB) shift left shamt-bits
  shifter sht(.dataIn(dataB), .amount(shamt), .select(SignaltoSHT), .dataOut(SHTOut));
  MUX mux(.sel(SignaltoMUX), .ALUOut(ALUOut), .HiOut(HiOut), .LoOut(LoOut), .SHTOut(SHTOut), .Output(Output));
  
endmodule