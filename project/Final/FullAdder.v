module FullAdder(A, B, cin, sum, cout);
  input A, B, cin;
  output sum, cout;
  wire e1, e2, e3;
  xor(e1, A, B);
  xor(sum, B, cin);
  and(e2, e1, cin);
  and(e3, A, B);
  or(cout, e2, e3);

endmodule
  