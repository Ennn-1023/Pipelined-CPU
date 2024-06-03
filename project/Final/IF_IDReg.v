module IF_IDReg(
    input clk,
    input rst,
    input enReg,
    input [31:0] pcIn,
    input [31:0] insIn,
    output reg [31:0] pcOut,
    output reg [31:0] insOut
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        pcOut <= 0;
        insOut <= 0;
    end
    else if (enReg) begin
        pcOut <= pcIn;
        insOut <= insIn;
    end
end

endmodule