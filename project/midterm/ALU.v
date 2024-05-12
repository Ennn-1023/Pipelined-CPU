module ALU(control, A, B, dataOut, reset);
  // I/O definition
  input[2:0] control;
  input[31:0] A, B;
  input reset;

  output[31:0] dataOut;
  
  wire cin;
  wire[31:0] sum;
  wire[31:0] carry;
  wire zero;
  assign cin = control[2]; // same as Binvert
  // 32bit ALU
  ALU_1bit ALU0(.control(control), .Ain(A[0]), .Bin(B[0]), .cin(cin), .Less(sum[31]), .result(sum[0]), .cout(carry[0]));
  ALU_1bit ALU1(.control(control), .Ain(A[1]), .Bin(B[1]), .cin(carry[0]), .Less(1'b0), .result(sum[1]), .cout(carry[1]));
  ALU_1bit ALU2(.control(control), .Ain(A[2]), .Bin(B[2]), .cin(carry[1]), .Less(1'b0), .result(sum[2]), .cout(carry[2]));
  ALU_1bit ALU3(.control(control), .Ain(A[3]), .Bin(B[3]), .cin(carry[2]), .Less(1'b0), .result(sum[3]), .cout(carry[3]));
  ALU_1bit ALU4(.control(control), .Ain(A[4]), .Bin(B[4]), .cin(carry[3]), .Less(1'b0), .result(sum[4]), .cout(carry[4]));
  ALU_1bit ALU5(.control(control), .Ain(A[5]), .Bin(B[5]), .cin(carry[4]), .Less(1'b0), .result(sum[5]), .cout(carry[5]));
  ALU_1bit ALU6(.control(control), .Ain(A[6]), .Bin(B[6]), .cin(carry[5]), .Less(1'b0), .result(sum[6]), .cout(carry[6]));
  ALU_1bit ALU7(.control(control), .Ain(A[7]), .Bin(B[7]), .cin(carry[6]), .Less(1'b0), .result(sum[7]), .cout(carry[7]));
  ALU_1bit ALU8(.control(control), .Ain(A[8]), .Bin(B[8]), .cin(carry[7]), .Less(1'b0), .result(sum[8]), .cout(carry[8]));
  ALU_1bit ALU9(.control(control), .Ain(A[9]), .Bin(B[9]), .cin(carry[8]), .Less(1'b0), .result(sum[9]), .cout(carry[9]));
  ALU_1bit ALU10(.control(control), .Ain(A[10]), .Bin(B[10]), .cin(carry[9]), .Less(1'b0), .result(sum[10]), .cout(carry[10]));
  ALU_1bit ALU11(.control(control), .Ain(A[11]), .Bin(B[11]), .cin(carry[10]), .Less(1'b0), .result(sum[11]), .cout(carry[11]));
  ALU_1bit ALU12(.control(control), .Ain(A[12]), .Bin(B[12]), .cin(carry[11]), .Less(1'b0), .result(sum[12]), .cout(carry[12]));
  ALU_1bit ALU13(.control(control), .Ain(A[13]), .Bin(B[13]), .cin(carry[12]), .Less(1'b0), .result(sum[13]), .cout(carry[13]));
  ALU_1bit ALU14(.control(control), .Ain(A[14]), .Bin(B[14]), .cin(carry[13]), .Less(1'b0), .result(sum[14]), .cout(carry[14]));
  ALU_1bit ALU15(.control(control), .Ain(A[15]), .Bin(B[15]), .cin(carry[14]), .Less(1'b0), .result(sum[15]), .cout(carry[15]));
  ALU_1bit ALU16(.control(control), .Ain(A[16]), .Bin(B[16]), .cin(carry[15]), .Less(1'b0), .result(sum[16]), .cout(carry[16]));
  ALU_1bit ALU17(.control(control), .Ain(A[17]), .Bin(B[17]), .cin(carry[16]), .Less(1'b0), .result(sum[17]), .cout(carry[17]));
  ALU_1bit ALU18(.control(control), .Ain(A[18]), .Bin(B[18]), .cin(carry[17]), .Less(1'b0), .result(sum[18]), .cout(carry[18]));
  ALU_1bit ALU19(.control(control), .Ain(A[19]), .Bin(B[19]), .cin(carry[18]), .Less(1'b0), .result(sum[19]), .cout(carry[19]));
  ALU_1bit ALU20(.control(control), .Ain(A[20]), .Bin(B[20]), .cin(carry[19]), .Less(1'b0), .result(sum[20]), .cout(carry[20]));
  ALU_1bit ALU21(.control(control), .Ain(A[21]), .Bin(B[21]), .cin(carry[20]), .Less(1'b0), .result(sum[21]), .cout(carry[21]));
  ALU_1bit ALU22(.control(control), .Ain(A[22]), .Bin(B[22]), .cin(carry[21]), .Less(1'b0), .result(sum[22]), .cout(carry[22]));
  ALU_1bit ALU23(.control(control), .Ain(A[23]), .Bin(B[23]), .cin(carry[22]), .Less(1'b0), .result(sum[23]), .cout(carry[23]));
  ALU_1bit ALU24(.control(control), .Ain(A[24]), .Bin(B[24]), .cin(carry[23]), .Less(1'b0), .result(sum[24]), .cout(carry[24]));
  ALU_1bit ALU25(.control(control), .Ain(A[25]), .Bin(B[25]), .cin(carry[24]), .Less(1'b0), .result(sum[25]), .cout(carry[25]));
  ALU_1bit ALU26(.control(control), .Ain(A[26]), .Bin(B[26]), .cin(carry[25]), .Less(1'b0), .result(sum[26]), .cout(carry[26]));
  ALU_1bit ALU27(.control(control), .Ain(A[27]), .Bin(B[27]), .cin(carry[26]), .Less(1'b0), .result(sum[27]), .cout(carry[27]));
  ALU_1bit ALU28(.control(control), .Ain(A[28]), .Bin(B[28]), .cin(carry[27]), .Less(1'b0), .result(sum[28]), .cout(carry[28]));
  ALU_1bit ALU29(.control(control), .Ain(A[29]), .Bin(B[29]), .cin(carry[28]), .Less(1'b0), .result(sum[29]), .cout(carry[29]));
  ALU_1bit ALU30(.control(control), .Ain(A[30]), .Bin(B[30]), .cin(carry[29]), .Less(1'b0), .result(sum[30]), .cout(carry[30]));
  ALU_1bit ALU31(.control(control), .Ain(A[31]), .Bin(B[31]), .cin(carry[30]), .Less(1'b0), .result(sum[31]), .cout(carry[31]));

  assign dataOut = sum;
endmodule