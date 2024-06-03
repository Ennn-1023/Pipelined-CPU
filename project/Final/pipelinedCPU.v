module pipelinedCPU(clk, reset);
  input clk, reset;
  
  
  wire[31:0] pc, instr;
  wire[5:0] opcode;
  wire[4:0] rs, rt, rd, shamt;
  wire[6:0] funct;
  wire[15:0] immed;
  wire[25:0] jumpOffest;
  
  assign opcode = instr[31:26];
  assign rs = instr[25:21];
  assign rt = instr[20:16];
  assign rd = instr[15:11];
  assign shamt = instr[10:6];
  assign funct = instr[5:0];
  assign immed = instr[15:0];
  assign jumpOffset = instr[25:0];
  // control signals
  wire RegWrite_ctrl, Branch_ctrl, PCSrc_ctrl, ResDst_ctrl;
  wire MemRead_ctrl, MemWrite_ctrl, ALUSrc_ctrl, Zero_ctrl, Jump_ctrl;
  wire[1:0] ALUop_ctrl;
  
  wire[31:0] pc_next, pc_incr, pc_IF, pc_ID, pc_EX, pc_addOffset;
  wire[31:0] pc_jump, pc_branch;
  
  // ####IF Stage####
  // pc register
  reg32 PC( .clk(clk), .rst(rst), .en_reg(1'b1), .d_in(pc_next), .d_out(pc) );
  // pc increment
  add32 pcAdd4(.a(pc), .b(32'd4), .result(pc_incr));
  // double mux for pc branch or jump
  mux2 branch_mux(.sel(PCSrc), .a(pc_incr), .b(pc_addOffset), .y(pc_branch));
  mux2 jump_mux(.sel(Jump), .a(pc_branch), .b(pc_jump), .y(pc_next));


  // instruction memory
  memory instr_mem( .clk(clk), .MemRead(1'b1), .MemWrite(1'b0), .wd(32'd0), .addr(pc), .rd(instr) );
  
  // store instr for next stage
  IF_IDReg IF_ID(.clk(clk), .rst(reset), .enReg(1'b1), .pcIn(pc_incr), .insIn(instr), .pcOut(pc_IF), .insOut(instr));
  
  /// ###ID Stage###
  wire[31:0] rd1, rd2;
  // Control Signal setting
  ControlUnit ctrl(.opcode(opcode), .ALUop(ALUop_ctrl), .RegWrite(RegWrite_ctrl), .Branch(Branch_ctrl), .MemRead(MemRead_ctrl),
                   .MemWrite(MemWrite_ctrl), .ALUSrc(ALUSrc_ctrl), .RegDst(RegDst_ctrl), .Zero(Zero_ctrl), .Jump(Jump_ctrl));
  wire[31:0] RegWrite_WB, WD_WB, RD_WB;
  reg_file regFile(.clk(clk), .RegWrite(RegWrite_WB), .RN1(rs), .RN2(rt),
   .WN(rd_WB), .WD(WD_WB), .RD1(rd1), .RD2(rd2));
  wire[31:0] immed32;
  // extend immediate value to 32-bits
  extend extend32(.immed(immed), .extOut(immed32));
  // store for next stage
  wire[31:0] RD1_ID, RD2_ID, immed_ID;
  wire[4:0] shamt_ID;
  wire[5:0] funct_ID;
  wire[1:0] ALUop_ID;
  wire[4:0] rd_ID, rt_ID;
  wire ALUSrc_ID;
  wire MemWrite_ID, MemRead_ID, MemtoReg_ID, RegWrite_ID, RegDst_ID;
  // to be set on
  // RegDst_in, RegDst_out
  // ALUSrc_in, ALUSrc_out
  ID_EXReg ID_EX(.clk(clk), .rst(reset), .enReg(1'b1), .RD1(rd1), .RD1Out(RD1_ID), .RD2(rd2), .RD2Out(RD2_ID),
                 .RegWrite_in(RegWrite_ctrl), .RegWrite_out(RegWrite_ID), .MemtoReg_in(MemtoReg_ctrl),
                 .MemtoReg_out(MemtoReg_ID), .MemWrite_in(MemWrite_ctrl), .MemWrite_out(MemWrite_ID),
                 .MemRead_in(MemRead_ctrl), .MemRead_out(MemRead_ID), .Branch_in(Branch_ctrl), .Branch_out(Branch_ID),
                 .ALUop_in(ALUop_ctrl), .ALUop_out(ALUop_ID), .pc_incr(pc_IF), .pcOut(pc_ID), .shamt(shamt), .shamtOut(),
                 .funct(funct), .functOut(funct_ID), .immed(immed32), .immedOut(immed_ID), .rt(rt), .rtOut(rt_ID),
                 .rd(rd), .rdOut(rd_ID), .RegDst_in(RegDst_ctrl), .RegDst_out(RegDst_ID), .ALUSrc_in(ALUSrc_ctrl),
                 .ALUSrc_out(ALUSrc_ID));
  
  // ####EX Stage####
  
  wire[31:0] dataB, ALUOut;
  wire Zero_ALU; // receive signal from ALU
  mux2 ALU_inputB(.sel(ALUSrc_ID), .a(RD2_ID), .b(immed_ID), .y(dataB));
  // ----ALU control ALUop need to be implemented
  // ----Zero need to be implemented
  TotalALU(.clk(clk), .rst(reset), .Signal(funct_ID), .ALUop(ALUop_ID), .dataA(RD1_ID),
           .dataB(dataB), .Output(ALUOut), .Zero(Zero_ALU));
  
  // select rt or rd to be write back into reg_file
  wire[4:0] WN_toMEM; // the reg number to be write back
  mux2 WN_select(.sel(RegDst_ID), .a(rt_ID), .b(rd_ID), .y(WN_toMEM));
  
  // ### pc+4 add offset << 2
  wire [31:0] shiftedOffset;
  // shift left 2 bit
  shifter offsetSHT(.select(1), .dataIn(immed_ID), .amount(5'd2), .dataOut(shiftedOffset));
  add32 branchAdder(.a(pc_ID), .b(shiftedOffset), .result(pc_EX)); // pc branch addr
  wire[4:0] WN_EX;
  wire[31:0] ALU_EX, RD2_EX;
  wire RegWrite_EX, MemtoReg_EX, MemWrite_EX, MemRead_EX, Branch_EX, Zero_EX;
  // ---Branch_in
  EX_MEMReg EX_MEM(.clk(clk), .rst(reset), .enReg(1'b1), .RegWrite_in(RegWrite_ID), .RegWrite_out(RegWrite_EX),
                  .MemtoReg_in(MemtoReg_ID), .MemtoReg_out(MemtoReg_EX), .MemWrite_in(MemWrite_ID), .MemWrite_out(MemWrite_EX),
                  .MemRead_in(MemRead_ID), .MemRead_out(MemRead_EX), .Branch_in(Branch_ID), .Branch_out(Branch_EX),
                  .Zero_in(Zero_ALU), .Zero_out(Zero_EX), .ALU_in(ALUOut), .ALU_out(ALU_EX), .WD_in(RD2_ID), .WD_out(RD2_EX),
                  .WN_in(WN_toMEM), .WN_out(WN_EX));
  // ####MEM Stage####
  wire[31:0] MemRD;
  memory data_mem(.clk(clk), .MemRead(MemRead_EX), .MemWrite(MemWrite_EX), .wd(WD_EX), .addr(ALU_EX), .rd(MemRD));
  // ### setting PCSrc for beq
  // PCSrc = Branch & Zero
  and(PCSrc, Branch_EX, Zero_EX);
  
  wire MemtoReg_MEM;
  wire[31:0] RD_MEM, ALU_MEM;
  MEM_WBReg MEM_WB(.clk(clk), .rst(reset), .enReg(1'b1), .RegWrite_in(RegWrite_EX), .RegWrite_out(RegWrite_WB),
                   .MemtoReg_in(MemtoReg_EX), .MemtoReg_out(MemtoReg_MEM), .RD_in(MemRD), .RD_out(RD_MEM),
                   .ALU_in(ALUEX), .ALU_out(ALU_MEM), .WN_in(WN_EX), .WN_out(WN_WB));
  // #####WB Stage#####
  // select a result to be write back into register file
  mux2 WriteBackSEL(.sel(MemtoReg_MEM), .a(ALU_MEM), .b(RD_MEM), .y(WD_WB));
  
endmodule