module Hazard(
input [4:0]IDEX_MemRead,
input [4:0] IDEX_RegisterRt,//
input [4:0] IFID_RegisterRs,
input [4:0] IFID_RegisterRt,
input  ID_RegWrite ,
input PCSrc,
input jump,
input EX_MemWrite,
input [4:0] writeAddres_MEM,
input [4:0] writeAddres_WB,
///OUTPUTS//
output logic En_PC,
output logic EN_REG,
output logic EN_CONTROL,
output logic Branch_Flush
);
logic signal;
always_comb 
  if (IDEX_MemRead && (((IDEX_RegisterRt== IFID_RegisterRs) && (IFID_RegisterRs!=5'b0)) ||  ((IDEX_RegisterRt== IFID_RegisterRt) && (IFID_RegisterRt!=5'b0)))) begin

En_PC = 1'b0;
EN_REG = 1'b1;
EN_CONTROL = 1'b1; 
Branch_Flush= 1'b1;
end 
else if ((PCSrc)&&((IFID_RegisterRs==writeAddres_MEM||IFID_RegisterRs==writeAddres_WB||IDEX_RegisterRt== IFID_RegisterRs)&& (IFID_RegisterRs!=5'b0))||((PCSrc)&&(IFID_RegisterRt==writeAddres_MEM||IFID_RegisterRt==writeAddres_WB||IDEX_RegisterRt== IFID_RegisterRt)&& (IFID_RegisterRt!=5'b0))) begin

En_PC = 1'b0;
EN_REG = 1'b1;
Branch_Flush= 1'b0;

end 
else if (jump)
begin
En_PC = 1'b1;
//EN_REG = 1'b1;
Branch_Flush= 1'b1;
end 
  else if(EX_MemWrite &&((IDEX_RegisterRt== IFID_RegisterRt)||(writeAddres_MEM== IFID_RegisterRt)||(writeAddres_WB== IFID_RegisterRt) ))
begin
En_PC = 1'b0;
EN_REG = 1'b1;
EN_CONTROL = 1'b1; 
Branch_Flush= 1'b1;
end 
  else if (ID_RegWrite && (((writeAddres_WB== IFID_RegisterRs) && (IFID_RegisterRs!=5'b0)) ||  ((writeAddres_WB== IFID_RegisterRt) && (IFID_RegisterRt!=5'b0)))) begin

En_PC = 1'b0;
EN_REG = 1'b1;
EN_CONTROL = 1'b1; 
Branch_Flush= 1'b1;
  end
else
begin
En_PC = 1'b1;
EN_REG = 1'b0;
EN_CONTROL = 1'b0; 
Branch_Flush= 1'b1;
 
end
  

  
    
endmodule