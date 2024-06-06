module ALUControl(
  input rst,
  input nop,
  input [1:0] ALUop,
  input [5:0] funct,
  output reg [1:0] SignaltoMUX,
  output reg SignaltoMULTU,
  output reg SignaltoSHT,
  output reg SignaltoHi,
  output reg SignaltoLo,
  output reg JR_Signal,
  output reg [2:0] operation
);
  // Define funct parameters
  parameter AND = 6'b100100;  // d36
  parameter OR  = 6'b100101;  // d37
  parameter ADD = 6'b100000;  // d32
  parameter SUB = 6'b100010;  // d34
  parameter SLT = 6'b101010;  // d42
  parameter SLL = 6'b000000;  // d0
  parameter MULTU = 6'b011001;// d25
  parameter JR  = 6'd8;
  parameter Hi = 6'd16;
  parameter Lo = 6'd18;
  
  
  // Always block to control ALU operations
  always @(nop or funct or ALUop or rst) begin
    if (rst) begin
      JR_Signal = 0;
      SignaltoMULTU = 0;
      SignaltoSHT = 0;
      SignaltoMUX = 2'b00;
      SignaltoHi = 0;
      SignaltoLo = 0;
      operation = 3'b000; // No operation
    end
    else begin
      JR_Signal = 0;
      if (nop) begin
        // If NOP signal is active, set all control signals to no operation
        SignaltoSHT = 0;
        SignaltoMUX = 2'b00;
        SignaltoHi = 0;
        SignaltoLo = 0;
        operation = 3'b000; // No operation
      end
      else begin
        // Default values for control signals
       	SignaltoSHT = 0;
        SignaltoMUX = 2'b00;
        SignaltoHi = 0;
        SignaltoLo = 0;
        // Determine ALU operation based on ALUop and funct
        case(ALUop)
          2'b00 : operation = 3'b010; // Load/Store
          2'b01 : operation = 3'b110; // Branch
          2'b11 : operation = 3'b000; // andi
          2'b10 : begin
            // R-type instructions
            if (funct == MULTU) begin
              SignaltoMULTU = 1;
            end
            else SignaltoMULTU = 0;
            
            if (funct == Hi) begin
              SignaltoHi = 1;
            end
            else if (funct == Lo) begin
              SignaltoLo = 1;
            end 
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
                  operation = 3'b010; // A + B (B == 0)
                  JR_Signal = 1;
                end
                default : operation = 3'bxxx;
              endcase
            end
          end
          default : operation = 3'bxxx;
        endcase
      end
    end
  end // end of always
endmodule
