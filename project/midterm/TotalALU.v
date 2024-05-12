module TotalALU(clk, rst, Signal, dataA, dataB, Output);
  input clk, rst;
  input[5:0] Signal;
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
  
  wire[5:0] SignaltoSHT, SignaltoMUX, SignaltoMULTU;
  wire[2:0] SignaltoALU;
  wire[31:0] ALUOut, HiOut, LoOut, ShifterOut;
  wire[31:0] dataOut;
  wire[63:0] MulAns;
  
  ALUControl ALUControl(.clk(clk), .Signal(Signal), .SignaltoALU(SignaltoALU), .SignaltoSHT(SignaltoSHT), 
                        .SignaltoMUX(SignaltoMUX), .SignaltoMULTU(SignaltoMULTU));
  ALU ALU(.control(SignaltoALU), .A(dataA), .B(dataB), .dataOut(ALUOut), .reset(rst));
  assign Output = ALUOut;
endmodule