module Adder(A, B, cin, sum, cout);
  input[31:0] A, B;
  output[31:0] sum;
  output cout;
  
  wire[30:0] carry;
  
  FullAdder FA0(.A(A[0]), .B(B[0]), .cin(cin), .sum(sum[0]), .cout(carry[0]));
  FullAdder FA1(.A(A[1]), .B(B[1]), .cin(carry[0]), .sum(sum[1]), .cout(carry[1]));
  FullAdder FA2(.A(A[2]), .B(B[2]), .cin(carry[1]), .sum(sum[2]), .cout(carry[2]));
  FullAdder FA3(.A(A[3]), .B(B[3]), .cin(carry[2]), .sum(sum[3]), .cout(carry[3]));
  FullAdder FA4(.A(A[4]), .B(B[4]), .cin(carry[3]), .sum(sum[4]), .cout(carry[4]));
  FullAdder FA5(.A(A[5]), .B(B[5]), .cin(carry[4]), .sum(sum[5]), .cout(carry[5]));
  FullAdder FA6(.A(A[6]), .B(B[6]), .cin(carry[5]), .sum(sum[6]), .cout(carry[6]));
  FullAdder FA7(.A(A[7]), .B(B[7]), .cin(carry[6]), .sum(sum[7]), .cout(carry[7]));
  FullAdder FA8(.A(A[8]), .B(B[8]), .cin(carry[7]), .sum(sum[8]), .cout(carry[8]));
  FullAdder FA9(.A(A[9]), .B(B[9]), .cin(carry[8]), .sum(sum[9]), .cout(carry[9]));
  FullAdder FA10(.A(A[10]), .B(B[10]), .cin(carry[9]), .sum(sum[10]), .cout(carry[10]));
  FullAdder FA11(.A(A[11]), .B(B[11]), .cin(carry[10]), .sum(sum[11]), .cout(carry[11]));
  FullAdder FA12(.A(A[12]), .B(B[12]), .cin(carry[11]), .sum(sum[12]), .cout(carry[12]));
  FullAdder FA13(.A(A[13]), .B(B[13]), .cin(carry[12]), .sum(sum[13]), .cout(carry[13]));
  FullAdder FA14(.A(A[14]), .B(B[14]), .cin(carry[13]), .sum(sum[14]), .cout(carry[14]));
  FullAdder FA15(.A(A[15]), .B(B[15]), .cin(carry[14]), .sum(sum[15]), .cout(carry[15]));
  FullAdder FA16(.A(A[16]), .B(B[16]), .cin(carry[15]), .sum(sum[16]), .cout(carry[16]));
  FullAdder FA17(.A(A[17]), .B(B[17]), .cin(carry[16]), .sum(sum[17]), .cout(carry[17]));
  FullAdder FA18(.A(A[18]), .B(B[18]), .cin(carry[17]), .sum(sum[18]), .cout(carry[18]));
  FullAdder FA19(.A(A[19]), .B(B[19]), .cin(carry[18]), .sum(sum[19]), .cout(carry[19]));
  FullAdder FA20(.A(A[20]), .B(B[20]), .cin(carry[19]), .sum(sum[20]), .cout(carry[20]));
  FullAdder FA21(.A(A[21]), .B(B[21]), .cin(carry[20]), .sum(sum[21]), .cout(carry[21]));
  FullAdder FA22(.A(A[22]), .B(B[22]), .cin(carry[21]), .sum(sum[22]), .cout(carry[22]));
  FullAdder FA23(.A(A[23]), .B(B[23]), .cin(carry[22]), .sum(sum[23]), .cout(carry[23]));
  FullAdder FA24(.A(A[24]), .B(B[24]), .cin(carry[23]), .sum(sum[24]), .cout(carry[24]));
  FullAdder FA25(.A(A[25]), .B(B[25]), .cin(carry[24]), .sum(sum[25]), .cout(carry[25]));
  FullAdder FA26(.A(A[26]), .B(B[26]), .cin(carry[25]), .sum(sum[26]), .cout(carry[26]));
  FullAdder FA27(.A(A[27]), .B(B[27]), .cin(carry[26]), .sum(sum[27]), .cout(carry[27]));
  FullAdder FA28(.A(A[28]), .B(B[28]), .cin(carry[27]), .sum(sum[28]), .cout(carry[28]));
  FullAdder FA29(.A(A[29]), .B(B[29]), .cin(carry[28]), .sum(sum[29]), .cout(carry[29]));
  FullAdder FA30(.A(A[30]), .B(B[30]), .cin(carry[29]), .sum(sum[30]), .cout(carry[30]));
  FullAdder FA31(.A(A[31]), .B(B[31]), .cin(carry[30]), .sum(sum[31]), .cout(cout));

endmodule