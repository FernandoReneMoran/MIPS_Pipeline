module forward(
///inputs//
input  EXMEM_RegWrite ,
input MemWrite_EX,
input [4:0] EXMEM_RegisterRd,
input [4:0]	IDEX_RegisterRs,
input  MEMWB_RegWrite,
input [4:0] MEMWB_RegisterRd,
input [4:0] IDEX_RegisterRt,
//input [1:0] Alu_op
///output//
output logic [1:0] ForwardA,
output logic [1:0] ForwardB);


//EX Forward Unit:
always_comb begin
if (EXMEM_RegWrite && (EXMEM_RegisterRd!= 0)&& (EXMEM_RegisterRd == IDEX_RegisterRs) )
 ForwardA = 2'b10;
else if ((MemWrite_EX==1'b0)&& MEMWB_RegWrite && (MEMWB_RegisterRd != 0)&& (EXMEM_RegisterRd != IDEX_RegisterRs)&& (MEMWB_RegisterRd == IDEX_RegisterRs))
 ForwardA= 2'b01;
else 
 ForwardA= 2'b00;
end

//MEM Forward Unit:
always_comb begin
if (EXMEM_RegWrite && (EXMEM_RegisterRd != 0)&& (EXMEM_RegisterRd == IDEX_RegisterRt) )
ForwardB = 2'b10;
else if ((MemWrite_EX==1'b0)&& MEMWB_RegWrite && (MEMWB_RegisterRd != 0)&& (EXMEM_RegisterRd != IDEX_RegisterRt) && (MEMWB_RegisterRd == IDEX_RegisterRt))
ForwardB= 2'b01;
else 
ForwardB= 2'b00;
end
endmodule