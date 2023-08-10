module shift_r #(parameter S= 32)(
input logic [S-1:0] in,
  output logic [S-1:0] out );

  assign out = {in[S-3:0],2'b00};
endmodule 
