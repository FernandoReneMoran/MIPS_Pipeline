module PC(clk,clr,data_in,data_out,en);
input clk, clr,en;
input [31:0] data_in;
output logic [31:0] data_out;


  always_ff @(posedge clk or posedge clr ) begin
	if(clr)
		data_out <= 32'b0;
		  else 
    if (en)
            data_out <= data_in;
  		else 
			data_out <=	 data_out;
end



endmodule 