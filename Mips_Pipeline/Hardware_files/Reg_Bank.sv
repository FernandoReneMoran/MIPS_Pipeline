
module Reg_Bank

#(
	// Parameter Declarations
	parameter WL = 32,   // Register Word-Length 
	parameter AL = 32    // Bits for Address location 
	)

(
	// Input Ports
	input clk, wr_en,rd1_en,rd2_en,rst,
  	input [AL-1:0] w_addr, r_addr1,r_addr2,
	input [WL-1:0] w_data,
  	output logic [WL-1:0] r_data1,r_data2
);

	// 
	logic [WL-1:0] RB [2**AL];
	
	always @(posedge clk)begin
    if (rst) 
   for (int i = 0; i < 2**AL; i++) begin
  RB[i] = '0;
end
      else if (wr_en && w_addr != '0)
			RB[w_addr] <= w_data;
	end
	
   // Read operation
    always_comb begin
    if(rd1_en == 1'b1)begin
		r_data1 = RB[r_addr1];
		end
		else
			r_data1 = 16'bx;
    if(rd2_en == 1'b1)begin
		r_data2 = RB[r_addr2];
	  end
	  else
		r_data2 = 16'bx;
  end
	
	
endmodule
	