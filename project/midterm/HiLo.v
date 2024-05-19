module HiLo( clk, Signal, multAns, HiOut, LoOut, reset );
input clk;
input [5:0] Signal ;
input reset ;
input [63:0] multAns ;
output [31:0] HiOut, LoOut ;

reg [31:0] HiReg, LoReg ;

parameter Hi = 6'd16;
parameter Lo = 6'd18;

always@( posedge clk or reset )
begin
  if ( reset )
  begin
    HiReg <= 32'b0;
    LoReg <= 32'b0;
  end
  else begin
      {HiReg, LoReg} <= multAns;
  end
end

assign HiOut = HiReg;
assign LoOut = LoReg;

endmodule