module ALUControl( clk, funct, ALUop, operation, SignaltoSHT, SignaltoMULTU,
                   SignaltoHi, SignaltoLo, SignaltoMUX, JR_Signal );
  // I/O
  input clk;
  input[1:0] ALUop;
  input[5:0] funct;
  output[1:0] SignaltoMUX;
  output SignaltoMULTU, SignaltoSHT;
  output SignaltoHi, SignaltoLo;
  output JR_Signal;
  output[2:0] operation;
  
  
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
  
  reg[2:0] operation;
  reg SignaltoMULTU, SignaltoSHT;
  reg[1:0] SignaltoMUX;
  reg SignaltoHi, SignaltoLo, JR_Signal;
  // connect input with output signal
  always@(ALUop or funct) begin
    SignaltoMULTU = 0;
    SignaltoMUX = 2'b00;
    SignaltoHi = 0;
    SignaltoLo = 0;
    JR_Signal = 0;
    case(ALUop)
      2'b00 : operation = 3'b010;
      2'b01 : operation = 3'b110;
      2'b10 : begin
        if (funct == MULTU) SignaltoMULTU = 1;
        else if (funct == Hi) SignaltoHi = 1;
        else if (funct == Lo) SignaltoLo = 1;
        else begin
          case(funct)
            AND : operation = 3'b000;
            OR  : operation = 3'b001;
            ADD : operation = 3'b010;
            SUB : operation = 3'b110;
            SLT : operation = 3'b111;
            SLL : begin
              SignaltoSHT = 1;
              SignaltoMUX = 2'b11;
            end
            Hi  : SignaltoMUX = 2'b01;
            Lo  : SignaltoMUX = 2'b10;
            JR  : begin
              operation = 3'b010; // A add B( B == 0)
              JR_Signal = 1;
            end
            default : operation = 3'bxxx;
          endcase
        end
      end
      default : operation = 3'bxxx;
    endcase
  end

  
endmodule