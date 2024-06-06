module FullAdder(A, B, cin, sum, cout);
  input A, B, cin;
  output sum, cout;
  wire e1, e2, e3;
  
  xor(e1, A, B);       // e1 = A XOR B
  xor(sum, e1, cin);   // sum = e1 XOR cin (A XOR B XOR cin)
  and(e2, e1, cin);    // e2 = e1 AND cin
  and(e3, A, B);       // e3 = A AND B
  or(cout, e2, e3);    // cout = e2 OR e3

endmodule