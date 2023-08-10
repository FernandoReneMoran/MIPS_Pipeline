module adder (
input logic [31:0] A,
input logic [31:0] B,
input logic en,
output logic [31:0] result);
always_comb
  if(en)
 result = A +B ;
 else 
   result=A +B- 4'b0100;

endmodule 


//adder ad1(.A(PC),.B({'0,0100})