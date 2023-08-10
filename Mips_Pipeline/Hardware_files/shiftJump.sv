module shift_rJump #(parameter S= 26)(
input logic [S-1:0] in,
output logic [S+1:0] out );

  assign out = {in[S-1:0],2'b00};
endmodule 
