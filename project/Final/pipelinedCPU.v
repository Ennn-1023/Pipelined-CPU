// multu, mfhi, mflo

// JR perform in EX stage ?? and JR_addr should be shift left 2 bit or not
module pipelinedCPU(clk, reset);
  input clk, reset;
  
  wire [31:0] pc, pc_next, pc_addOffset, pc_branch, pc_jump, instr_IF, instr_ID;
  wire [31:0] jump_addr, jump_addr_toEX;
  wire [5:0] opcode;
  wire [4:0] rs, rt, rd, shamt;
  wire [5:0] funct, funct_ID;
  wire [15:0] immed;
  wire [25:0] jumpOffset;
  wire [31:0] immed32;
  wire [31:0] b_Immed;
  wire [31:0] rd1, rd2;
  wire [31:0] regWD_WB, regWD_EX;
  wire [4:0] regWN_WB, regWN_EX, regWN_toMEM;
  
  // cut instruction
  assign opcode = instr_ID[31:26];
  assign rs = instr_ID[25:21];
  assign rt = instr_ID[20:16];
  assign rd = instr_ID[15:11];
  assign shamt = instr_ID[10:6];
  assign funct = instr_ID[5:0];
  assign immed = instr_ID[15:0];
  assign jumpOffset = instr_ID[25:0];
  
  // Control signals
  wire [31:0] ALU_EX;
  wire Branch_ctrl, Branch_ID;
  wire RegWrite_ctrl, RegWrite_WB, RegWrite_ID, RegWrite_EX;
  wire RegDst_ctrl, RegDst_ID;
  wire PCSrc;
  wire MemRead_ctrl, MemRead_ID, MemRead_EX;
  wire MemWrite_ctrl, MemWrite_ID, MemWrite_EX;
  wire MemtoReg_ctrl, MemtoReg_ID, MemtoReg_EX, MemtoReg_MEM;
  wire ALUSrc_ctrl, ALUSrc_ID, Jump_ctrl, Jump_ID;
  wire [1:0] ALUop_ctrl;
  wire JR_signal;
  wire [31:0] pc_incr, pc_IF, pc_ID, pc_EX;
  wire [31:0] ALUOut; // ALU output in EX stage
  // ########IF Stage#######
  // PC register
  reg32 PC(.clk(clk), .rst(reset), .en_reg(1'b1), .d_in(pc_next), .d_out(pc));
  // PC increment
  add32 pcAdd4(.a(pc), .b(32'd4), .result(pc_incr));
  // Double mux for PC branch or jump
  mux2 branch_mux(.sel(PCSrc), .a(pc_incr), .b(pc_addOffset), .y(pc_branch));
  // branch or jump (j & jr)
  // JR address or jump address
  assign jump_addr = {pc_IF[31:28], jumpOffset, 2'b00}; // concat jump immed
  mux2 JRmux(.sel(JR_signal), .a(jump_addr_toEX), .b(ALUOut), .y(pc_jump));
  wire jumpSignal; // j or jr
  or(jumpSignal, Jump_ID, JR_signal); // j or jr, do jump selection , perform in EX stage
  mux2 jump_mux(.sel(jumpSignal), .a(pc_branch), .b(pc_jump), .y(pc_next));
  
  // Instruction memory, fetch instruction
  memory instr_mem(.clk(clk), .MemRead(1'b1), .MemWrite(1'b0), .wd(32'd0), .addr(pc), .rd(instr_IF));
  
  // ########END of IF Stage########
  // Store instruction for next stage
  IF_IDReg IF_ID(.clk(clk), .rst(reset), .enReg(1'b1), .pcIn(pc_incr), .insIn(instr_IF), .pcOut(pc_IF), .insOut(instr_ID));
  
  /// ########ID Stage########
  wire nop_ctrl;
  ControlUnit ctrl(.instr(instr_ID), .ALUop(ALUop_ctrl), .RegWrite(RegWrite_ctrl), .Branch(Branch_ctrl), 
                   .MemRead(MemRead_ctrl), .MemWrite(MemWrite_ctrl), .MemtoReg(MemtoReg_ctrl), .ALUSrc(ALUSrc_ctrl), 
                   .RegDst(RegDst_ctrl), .Jump(Jump_ctrl), .nopSignal(nop_ctrl));
  
  reg_file regFile(.clk(clk), .RegWrite(RegWrite_WB), .RN1(rs), .RN2(rt),
                   .WN(regWN_WB), .WD(regWD_WB), .RD1(rd1), .RD2(rd2));
  
  // Extend immediate value to 32-bits
  extend extend32(.immed(immed), .extOut(immed32));
  // ########End of ID Stage########
  // Store for next stage
  wire [31:0] RD1_ID, RD2_ID, immed_ID;
  wire [4:0] shamt_ID;
  wire [1:0] ALUop_ID;
  wire [4:0] rd_ID, rt_ID;
  wire nop_toALU;
  ID_EXReg ID_EX(.clk(clk), .rst(reset), .enReg(1'b1), .RD1(rd1), .RD1Out(RD1_ID), .RD2(rd2), .RD2Out(RD2_ID),
                 .RegWrite_in(RegWrite_ctrl), .RegWrite_out(RegWrite_ID), .MemtoReg_in(MemtoReg_ctrl),
                 .MemtoReg_out(MemtoReg_ID), .MemWrite_in(MemWrite_ctrl), .MemWrite_out(MemWrite_ID),
                 .MemRead_in(MemRead_ctrl), .MemRead_out(MemRead_ID), .Branch_in(Branch_ctrl), .Branch_out(Branch_ID),
                 .ALUop_in(ALUop_ctrl), .ALUop_out(ALUop_ID), .pc_incr(pc_IF), .pcOut(pc_ID), .shamt(shamt), .shamtOut(shamt_ID),
                 .funct(funct), .functOut(funct_ID), .immed(immed32), .immedOut(immed_ID), .rt(rt), .rtOut(rt_ID),
                 .rd(rd), .rdOut(rd_ID), .RegDst_in(RegDst_ctrl), .RegDst_out(RegDst_ID), .ALUSrc_in(ALUSrc_ctrl),
                 .ALUSrc_out(ALUSrc_ID), .Jump_in(Jump_ctrl), .Jump_out(Jump_ID), .nop_in(nop_ctrl), .nop_out(nop_toALU),
                 .Jump_addr_in(jump_addr), .Jump_addr_out(jump_addr_toEX));
  
  // ########EX Stage########
  wire [31:0] dataB;
  wire Zero_ALU; // Receive signal from ALU
  mux2 ALU_inputB(.sel(ALUSrc_ID), .a(RD2_ID), .b(immed_ID), .y(dataB));
  // ------------shamt unimplemented
  // ALU ctrl signals
  wire[2:0] SignaltoALU;
  wire SignaltoMULTU, SignaltoSHT, SignaltoHi, SingaltoLo;
  wire[1:0] SignaltoMUX;
  ALUControl ALUctrl(.clk(clk), .nop(nop_toALU), .ALUop(ALUop_ID), .funct(funct_ID), .operation(SignaltoALU), .SignaltoSHT(SignaltoSHT), .JR_Signal(JR_signal),
                     .SignaltoHi(SignaltoHi), .SignaltoLo(SingaltoLo), .SignaltoMUX(SignaltoMUX), .SignaltoMULTU(SignaltoMULTU));
  // ALU and multiplier
  TotalALU ALU_MUL(.clk(clk), .rst(reset), .operation(SignaltoALU), .SignaltoSHT(SignaltoSHT),
                   .SignaltoMULTU(SignaltoMULTU), .SignaltoMUX(SignaltoMUX), .dataA(RD1_ID), .dataB(dataB),
                   .shamt(shamt_ID), .Output(ALUOut), .Zero(Zero_ALU));
  
  // Select rt or rd to be written back into reg_file
  mux2 #(5) RN2sel(.sel(RegDst_ID), .a(rt_ID), .b(rd_ID), .y(regWN_toMEM));
  
  // PC+4 add offset << 2
  // Shift left 2 bits
  shifter offsetSHT(.select(1'b1), .dataIn(immed_ID), .amount(5'd2), .dataOut(b_Immed));
  add32 branchAdder(.a(pc_ID), .b(b_Immed), .result(pc_addOffset)); // PC branch address
  
  // ########End of EX Stage########
  
  EX_MEMReg EX_MEM(.clk(clk), .rst(reset), .enReg(1'b1), .RegWrite_in(RegWrite_ID), .RegWrite_out(RegWrite_EX),
                   .MemtoReg_in(MemtoReg_ID), .MemtoReg_out(MemtoReg_EX), .MemWrite_in(MemWrite_ID), .MemWrite_out(MemWrite_EX),
                   .MemRead_in(MemRead_ID), .MemRead_out(MemRead_EX), .ALU_in(ALUOut),
                   .ALU_out(ALU_EX), .WD_in(RD2_ID), .WD_out(regWD_EX), .WN_in(regWN_toMEM), .WN_out(regWN_EX));
  
  // ###########MEM Stage############
  wire [31:0] MemRD;
  memory data_mem(.clk(clk), .MemRead(MemRead_EX), .MemWrite(MemWrite_EX), .wd(regWD_EX), .addr(ALU_EX), .rd(MemRD));
  
  // Setting PCSrc for beq
  // PCSrc = Branch & Zero
  and (PCSrc, Branch_ID, Zero_ALU);
  
  wire [31:0] RD_MEM, ALU_MEM;
  // ########End of MEM Stage########
  MEM_WBReg MEM_WB(.clk(clk), .rst(reset), .enReg(1'b1), .RegWrite_in(RegWrite_EX), .RegWrite_out(RegWrite_WB),
                   .MemtoReg_in(MemtoReg_EX), .MemtoReg_out(MemtoReg_MEM), .RD_in(MemRD), .RD_out(RD_MEM),
                   .ALU_in(ALU_EX), .ALU_out(ALU_MEM), .WN_in(regWN_EX), .WN_out(regWN_WB));
  
  // ##########WB Stage############
  // Select a result to be written back into register file
  mux2 WriteBackSEL(.sel(MemtoReg_MEM), .a(ALU_MEM), .b(RD_MEM), .y(regWD_WB));
  
endmodule