
module extend( immed, extOut );
    input [15:0] immed;
    output [31:0] extOut;
    
    // Perform unsigned extension by padding zeros on the left
    assign extOut = {16'b0, immed};
endmodule
