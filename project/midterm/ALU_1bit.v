module ALU_1bit(control, Ain, Bin, cin, Less, result, cout);
  // I/O def
  input[2:0] control;
  input Ain, Bin, cin, Less;
  output result, cout;
  
  // signal def
  parameter AND = 2'b00;
  parameter OR  = 2'b01;
  parameter ADD = 2'b10; // add or sub
  parameter SLT = 2'b11;
  
  wire e0, e1, e2, e3;
  wire[1:0] operation;
  wire Binvert;
  assign operation = control[1:0];
  assign Binvert = control[2];
  // perfrom 4 type of operation
  and(e0, Ain, Bin);
  or(e1, Ain, Bin);
  FullAdder adder(.A(Ain), .B(Bin^Binvert), .cin(cin), .sum(e2), .cout(cout));
  assign e3 = Less;

  // mux
  assign result = (operation == AND)? e0 :
                  (operation == OR)? e1 :
                  (operation == ADD)? e2:
                  e3;
endmodule