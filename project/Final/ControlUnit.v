module ControlUnit(opcode, ALUop, RegWrite, Branch, RegDst, MemRead, MemWrite, MemtoReg, ALUSrc, Jump);
  input[5:0] opcode;
  output RegWrite, Branch, RegDst, MemRead, MemWrite, ALUSrc, Jump, MemtoReg;
  output[1:0] ALUop;
  
  reg RegWrite, Branch, RegDst, MemRead, MemWrite, ALUSrc, Jump, MemtoReg;
  reg[1:0] ALUop;
  parameter R_FORMAT = 6'd0;
  parameter LW = 6'd35;
  parameter SW = 6'd43;
  parameter BEQ = 6'd4;
	parameter J = 6'd2;
  
  always@(opcode) begin
    case(opcode)
      R_FORMAT:
      begin
        ALUop = 2'b10;
        RegDst = 1; RegWrite = 1; MemRead = 0; MemWrite = 0;
        ALUSrc = 0; Jump = 0; Branch = 0; MemtoReg = 1'bx;
      end
      LW:
      begin
        ALUop = 2'b00; // ALU perform add
        RegDst = 1'bx; RegWrite = 1; MemRead = 1; MemWrite = 0;
        ALUSrc = 1; Jump = 0; Branch = 0; MemtoReg = 1'bx;
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
        RegWrite = 0; Jump = 0; Branch = 0; MemtoReg = 0;
      end
      default:
      begin
        $display("control_single unimplemented opcode %d", opcode);
				RegDst=1'bx; ALUSrc=1'bx; MemtoReg=1'bx; RegWrite=1'bx; MemRead=1'bx; 
				MemWrite=1'bx; Branch=1'bx; Jump = 1'bx; ALUop = 2'bxx;
			end
		endcase
	end
endmodule
