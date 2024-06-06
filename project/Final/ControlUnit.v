module ControlUnit(instr, ALUop, RegWrite, Branch, RegDst, MemRead, MemWrite, MemtoReg, ALUSrc, Jump, nopSignal);
  input[31:0] instr;
  output RegWrite, Branch, RegDst, MemRead, MemWrite, ALUSrc, Jump, MemtoReg;
  output[1:0] ALUop;
  output nopSignal;
  
  reg nopSignal;
  reg RegWrite, Branch, RegDst, MemRead, MemWrite, ALUSrc, Jump, MemtoReg;
  reg[1:0] ALUop;
  parameter R_FORMAT = 6'd0;
  parameter LW = 6'd35;
  parameter SW = 6'd43;
  parameter BEQ = 6'd4;
	parameter J = 6'd2;
  parameter ANDI = 6'd12; // 0xC i-type
  
  wire [5:0] opcode;
  assign opcode = instr[31:26];
  
  always@(instr) begin
    if (instr == 32'd0) begin
      nopSignal = 1;  ALUop = 2'b10;
      RegDst = 0; RegWrite = 0; MemRead = 0; MemWrite = 0;
      ALUSrc = 0; Jump = 0; Branch = 0; MemtoReg = 1'b0;
    end
    else begin
      nopSignal = 0; 
      case(opcode)
        R_FORMAT:
        begin
          ALUop = 2'b10;
          RegDst = 1; RegWrite = 1; MemRead = 0; MemWrite = 0;
          ALUSrc = 0; Jump = 0; Branch = 0; MemtoReg = 1'b0;
        end
        LW:
        begin
          ALUop = 2'b00; // ALU perform add
          RegDst = 1'bx; RegWrite = 1; MemRead = 1; MemWrite = 0;
          ALUSrc = 1; Jump = 0; Branch = 0; MemtoReg = 1'b1;
        end
        SW:
        begin
          ALUop = 2'b00; // ALU perform add
          RegDst = 0; ALUSrc = 1; MemRead = 0; MemWrite = 1;
          RegWrite = 0; Jump = 0; Branch = 0; MemtoReg = 0;
        end
        BEQ:
        begin
          ALUop = 2'b01; // ALU perform sub
          RegDst = 1'bx; ALUSrc = 0; MemRead = 0; MemWrite = 0;
          RegWrite = 0; Jump = 0; Branch = 1; MemtoReg = 0;
        end
        J:
        begin
          ALUop = 2'b01;
          RegDst = 1'bx; ALUSrc = 0; MemRead = 0; MemWrite = 0;
          RegWrite = 0; Jump = 1; Branch = 0; MemtoReg = 0;
        end
        ANDI: // ALUSrc = 1, inputB is immed
        begin
          ALUop = 2'b11;
          RegDst = 1'b0; ALUSrc = 1; MemRead = 0; MemWrite = 0;
          RegWrite = 1; Jump = 0; Branch = 0; MemtoReg = 0;
        end
        default:
        begin
          $display("control_single unimplemented opcode %d", opcode);
				  RegDst=1'bx; ALUSrc=1'bx; MemtoReg=1'bx; RegWrite=1'bx; MemRead=1'bx; 
				  MemWrite=1'bx; Branch=1'bx; Jump = 1'bx; ALUop = 2'bxx;
			  end
		  endcase
    end
  end
endmodule
