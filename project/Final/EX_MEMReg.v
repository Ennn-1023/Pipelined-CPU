module EX_MEMReg(
    input clk,
    input rst,
    input enReg,
    input RegWrite_in,
    input MemtoReg_in,
    input MemWrite_in,
    input MemRead_in,
    input Branch_in,
    input Zero_in,
    input [31:0] ALU_in,
    input [31:0] WD_in,
    input [4:0] WN_in,
    output reg RegWrite_out,
    output reg MemtoReg_out,
    output reg MemWrite_out,
    output reg MemRead_out,
    output reg Branch_out,
    output reg Zero_out,
    output reg [31:0] ALU_out,
    output reg [31:0] WD_out,
    output reg [4:0] WN_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        {RegWrite_out, MemtoReg_out, MemWrite_out, MemRead_out, Branch_out, Zero_out, ALU_out, WD_out, WN_out} <= 0;
    end
    else if (enReg) begin
        RegWrite_out <= RegWrite_in;
        MemtoReg_out <= MemtoReg_in;
        MemWrite_out <= MemWrite_in;
        MemRead_out <= MemRead_in;
        Branch_out <= Branch_in;
        Zero_out <= Zero_in;
        ALU_out <= ALU_in;
        WD_out <= WD_in;
        WN_out <= WN_in;
    end
end

endmodule
