module ID_EXReg(
    input clk,
    input rst,
    input enReg,
    input RegWrite_in,
    input MemtoReg_in,
    input MemRead_in,
    input MemWrite_in,
    input Branch_in,
    input RegDst_in,
    input ALUSrc_in,
    input [1:0] ALUop_in,
    input [3:0] pc_incr,
    input [4:0] shamt,
    input [5:0] funct,
    input [31:0] RD1,
    input [31:0] RD2,
    input [31:0] immed,
    input [4:0] rt,
    input [4:0] rd,
    output reg RegWrite_out,
    output reg MemtoReg_out,
    output reg MemRead_out,
    output reg MemWrite_out,
    output reg Branch_out,
    output reg RegDst_out,
    output reg ALUSrc_out,
    output reg [1:0] ALUop_out,
    output reg [3:0] pcOut,
    output reg [4:0] shamtOut,
    output reg [5:0] functOut,
    output reg [31:0] RD1Out,
    output reg [31:0] RD2Out,
    output reg [31:0] immedOut,
    output reg [4:0] rtOut,
    output reg [4:0] rdOut
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        {RegWrite_out, MemtoReg_out, MemWrite_out, MemRead_out, pcOut, RegDst_out,
         ALUSrc_out, shamtOut, functOut, RD1Out, RD2Out, immedOut, rtOut, rdOut} <= 0;
    end
    else if (enReg) begin
        RegWrite_out <= RegWrite_in;
        MemtoReg_out <= MemtoReg_in;
        MemWrite_out <= MemWrite_in;
        MemRead_out <= MemRead_in;
        Branch_out <= Branch_in;
        RegDst_out <= RegDst_in;
        ALUSrc_out <= ALUSrc_in;
        pcOut <= pc_incr;
        shamtOut <= shamt;
        functOut <= funct;
        RD1Out <= RD1;
        RD2Out <= RD2;
        immedOut <= immed;
        rtOut <= rt;
        rdOut <= rd;
    end
end

endmodule