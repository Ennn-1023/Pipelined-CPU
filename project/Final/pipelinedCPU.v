// pc branch mux need to detect PCSrc = x

module pipelinedCPU(clk, reset);
  input clk, reset;
  
  wire [31:0] pc, instr_IF, instr_ID;
  wire [5:0] opcode;
  wire [4:0] rs, rt, rd, shamt;
  wire [5:0] funct;
  wire [15:0] immed;
  wire [25:0] jumpOffset;

  assign opcode = instr_ID[31:26];
  assign rs = instr_ID[25:21];
  assign rt = instr_ID[20:16];
  assign rd = instr_ID[15:11];
  assign shamt = instr_ID[10:6];
  assign funct = instr_ID[5:0];
  assign immed = instr_ID[15:0];
  assign jumpOffset = instr_ID[25:0];
  
  // Control signals
  wire RegWrite_ctrl, Branch_ctrl, PCSrc, ResDst_ctrl;
  wire MemRead_ctrl, MemWrite_ctrl, MemtoReg_ctrl, ALUSrc_ctrl, Jump_ctrl;
  wire [1:0] ALUop_ctrl;

  wire [31:0] pc_next, pc_incr, pc_IF, pc_ID, pc_EX, pc_addOffset;
  wire [31:0] pc_jump, pc_branch;
  
  // ####IF Stage####
  // PC register
  reg32 PC(.clk(clk), .rst(reset), .en_reg(1'b1), .d_in(pc_next), .d_out(pc));
  // PC increment
  add32 pcAdd4(.a(pc), .b(32'd4), .result(pc_incr));
  // Double mux for PC branch or jump
  mux2 branch_mux(.sel(PCSrc), .a(pc_incr), .b(pc_addOffset), .y(pc_branch));
  mux2 jump_mux(.sel(Jump_ctrl), .a(pc_branch), .b(pc_jump), .y(pc_next));

  // Instruction memory, fetch instruction
  memory instr_mem(.clk(clk), .MemRead(1'b1), .MemWrite(1'b0), .wd(32'd0), .addr(pc), .rd(instr_IF));

  // Store instruction for next stage
  IF_IDReg IF_ID(.clk(clk), .rst(reset), .enReg(1'b1), .pcIn(pc_incr), .insIn(instr_IF), .pcOut(pc_IF), .insOut(instr_ID));
  
  /// ###ID Stage###
  wire [31:0] rd1, rd2;
  ControlUnit ctrl(.opcode(opcode), .ALUop(ALUop_ctrl), .RegWrite(RegWrite_ctrl), .Branch(Branch_ctrl), 
                   .MemRead(MemRead_ctrl), .MemWrite(MemWrite_ctrl), .MemtoReg(MemtoReg_ctrl), .ALUSrc(ALUSrc_ctrl), 
                   .RegDst(ResDst_ctrl), .Jump(Jump_ctrl));
  
  wire [31:0] WD_WB, RD_WB;
  wire [4:0] WN_WB;
  wire RegWrite_WB;
  reg_file regFile(.clk(clk), .RegWrite(RegWrite_WB), .RN1(rs), .RN2(rt),
                   .WN(WN_WB), .WD(WD_WB), .RD1(rd1), .RD2(rd2));
  
  wire [31:0] immed32;
  // Extend immediate value to 32-bits
  extend extend32(.immed(immed), .extOut(immed32));
  
  // Store for next stage
  wire [31:0] RD1_ID, RD2_ID, immed_ID;
  wire [4:0] shamt_ID;
  wire [5:0] funct_ID;
  wire [1:0] ALUop_ID;
  wire [4:0] rd_ID, rt_ID;
  wire ALUSrc_ID;
  wire MemWrite_ID, MemRead_ID, MemtoReg_ID, RegWrite_ID, RegDst_ID, Branch_ID;
  
  ID_EXReg ID_EX(.clk(clk), .rst(reset), .enReg(1'b1), .RD1(rd1), .RD1Out(RD1_ID), .RD2(rd2), .RD2Out(RD2_ID),
                 .RegWrite_in(RegWrite_ctrl), .RegWrite_out(RegWrite_ID), .MemtoReg_in(MemtoReg_ctrl),
                 .MemtoReg_out(MemtoReg_ID), .MemWrite_in(MemWrite_ctrl), .MemWrite_out(MemWrite_ID),
                 .MemRead_in(MemRead_ctrl), .MemRead_out(MemRead_ID), .Branch_in(Branch_ctrl), .Branch_out(Branch_ID),
                 .ALUop_in(ALUop_ctrl), .ALUop_out(ALUop_ID), .pc_incr(pc_IF), .pcOut(pc_ID), .shamt(shamt), .shamtOut(shamt_ID),
                 .funct(funct), .functOut(funct_ID), .immed(immed32), .immedOut(immed_ID), .rt(rt), .rtOut(rt_ID),
                 .rd(rd), .rdOut(rd_ID), .RegDst_in(ResDst_ctrl), .RegDst_out(RegDst_ID), .ALUSrc_in(ALUSrc_ctrl),
                 .ALUSrc_out(ALUSrc_ID));
  
  // ####EX Stage####
  wire [31:0] dataB, ALUOut;
  wire Zero_ALU; // Receive signal from ALU
  mux2 ALU_inputB(.sel(ALUSrc_ID), .a(RD2_ID), .b(immed_ID), .y(dataB));
  
  // ALU and Zero signal
  TotalALU ALU_MUL(.clk(clk), .rst(reset), .funct(funct_ID), .ALUop(ALUop_ID), .dataA(RD1_ID), .dataB(dataB), .Output(ALUOut), .Zero(Zero_ALU));
  
  // Select rt or rd to be written back into reg_file
  wire [4:0] WN_toMEM; // The reg number to be written back
  assign WN_toMEM = (RegDst_ID) ? rd_ID : rt_ID;
  
  // PC+4 add offset << 2
  wire [31:0] shiftedOffset;
  // Shift left 2 bits
  shifter offsetSHT(.select(1'b1), .dataIn(immed_ID), .amount(5'd2), .dataOut(shiftedOffset));
  add32 branchAdder(.a(pc_ID), .b(shiftedOffset), .result(pc_addOffset)); // PC branch address
  
  wire [4:0] WN_EX;
  wire [31:0] ALU_EX, WD_EX;
  wire RegWrite_EX, MemtoReg_EX, MemWrite_EX, MemRead_EX, Branch_EX, Zero_EX;
  
  EX_MEMReg EX_MEM(.clk(clk), .rst(reset), .enReg(1'b1), .RegWrite_in(RegWrite_ID), .RegWrite_out(RegWrite_EX),
                   .MemtoReg_in(MemtoReg_ID), .MemtoReg_out(MemtoReg_EX), .MemWrite_in(MemWrite_ID), .MemWrite_out(MemWrite_EX),
                   .MemRead_in(MemRead_ID), .MemRead_out(MemRead_EX), .Branch_in(Branch_ID), .Branch_out(Branch_EX),
                   .Zero_in(Zero_ALU), .Zero_out(Zero_EX), .ALU_in(ALUOut), .ALU_out(ALU_EX), .WD_in(RD2_ID), .WD_out(WD_EX),
                   .WN_in(WN_toMEM), .WN_out(WN_EX));
  
  // ####MEM Stage####
  wire [31:0] MemRD;
  memory data_mem(.clk(clk), .MemRead(MemRead_EX), .MemWrite(MemWrite_EX), .wd(WD_EX), .addr(ALU_EX), .rd(MemRD));
  
  // Setting PCSrc for beq
  // PCSrc = Branch & Zero
  and (PCSrc, Branch_EX, Zero_EX);
  
  wire MemtoReg_MEM;
  wire [31:0] RD_MEM, ALU_MEM;
  
  MEM_WBReg MEM_WB(.clk(clk), .rst(reset), .enReg(1'b1), .RegWrite_in(RegWrite_EX), .RegWrite_out(RegWrite_WB),
                   .MemtoReg_in(MemtoReg_EX), .MemtoReg_out(MemtoReg_MEM), .RD_in(MemRD), .RD_out(RD_MEM),
                   .ALU_in(ALU_EX), .ALU_out(ALU_MEM), .WN_in(WN_EX), .WN_out(WN_WB));
  
  // #####WB Stage#####
  // Select a result to be written back into register file
  mux2 WriteBackSEL(.sel(MemtoReg_MEM), .a(ALU_MEM), .b(RD_MEM), .y(WD_WB));
  
endmodule