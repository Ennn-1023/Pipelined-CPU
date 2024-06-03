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
  
  wire andresult, orResult, addResult, lessResult;
  wire[1:0] operation;
  wire Binvert;
  assign operation = control[1:0];
  assign Binvert = control[2];
  // perfrom 4 type of operation
  and(andresult, Ain, Bin);
  or(orResult, Ain, Bin);
  FullAdder adder(.A(Ain), .B(Bin^Binvert), .cin(cin), .sum(addResult), .cout(cout));
  assign lessResult = Less;

  // mux
  assign result = (operation == AND)? andresult :
                  (operation == OR)? orResult :
                  (operation == ADD)? addResult :
                  (Less == 1)? addResult : lessResult;
endmodule