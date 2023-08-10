// Code your testbench here
// or browse Examples
`include "Reg_Bank.sv"
`include "asyncmem.sv"
`include "asyncmemROM.sv"
`include "control.sv"
`include "mux.sv"
`include "PC.sv"
`include "shift_r.sv"
`include "shiftJump.sv"
`include "sign.sv"
`include "adder.sv"
`include "alu.sv"
`include "alu_control.sv"
`include "forward.sv"
`include "Hazard.sv"
`include "MIPS.sv"



module MIPS_TB();
logic [31:0] alu;
logic clk,clr;
  logic [31:0] R0,R1,R2,R3,R4,R5,R6,R7,R31,R10,R11;  
  logic [31:0] RA0,RA1,RA2,RA3,RA4,RA5,RA6,RA7,RA8,RA9,RA13,RA10;  
MIPS DUT(
.clk(clk),
.clr(clr),
.alu(alu)
);
  assign R0= DUT.Reg_Bank0.RB[0];
  assign R1= DUT.Reg_Bank0.RB[1];
  assign R2= DUT.Reg_Bank0.RB[2];
  assign R3= DUT.Reg_Bank0.RB[3];
  assign R4= DUT.Reg_Bank0.RB[4];
  assign R5= DUT.Reg_Bank0.RB[5];
  assign R6= DUT.Reg_Bank0.RB[6];
  assign R7= DUT.Reg_Bank0.RB[7];
  assign R10= DUT.Reg_Bank0.RB[10];
  assign R11= DUT.Reg_Bank0.RB[11];
  assign R31= DUT.Reg_Bank0.RB[31];
  
  assign RA0=DUT.RAM.mem_array[0];
  assign RA1=DUT.RAM.mem_array[1];
  assign RA2=DUT.RAM.mem_array[2];
  assign RA3=DUT.RAM.mem_array[3];
  assign RA4=DUT.RAM.mem_array[4];
  assign RA5=DUT.RAM.mem_array[5]; 
  assign RA6=DUT.RAM.mem_array[6]; 
  assign RA7=DUT.RAM.mem_array[7]; 
  assign RA8=DUT.RAM.mem_array[8]; 
  assign RA9=DUT.RAM.mem_array[9];
  assign RA10=DUT.RAM.mem_array[10]; 
  assign RA13=DUT.RAM.mem_array[13]; 
 
  
  
  
  initial begin
 #1500 $stop;
 end 
  
initial begin
  #0 clk = 0;
  forever begin
  	#5 clk = ~clk;
  end
end

 initial begin
      $dumpfile("dump.vcd"); $dumpvars;
   #0 clr = 1;
     #10 clr = 0;
   //	 #5 clr = 0;
   //Algoritmo de Canvas


   //Precarga RAM
   DUT.RAM.mem_array[0] = 32'h00000008;
   DUT.RAM.mem_array[1] = 32'h00000006;
   DUT.RAM.mem_array[2] = 32'h00000005;
   DUT.RAM.mem_array[3] = 32'h00000001;
   DUT.RAM.mem_array[4] = 32'h00000007;	 
   DUT.RAM.mem_array[5] = 32'h00000009;
   DUT.RAM.mem_array[6] = 32'h00000008;
   DUT.RAM.mem_array[7] = 32'h00000004;
   DUT.RAM.mem_array[8] = 32'h00000005;
   DUT.RAM.mem_array[9] = 32'h0000000A;
   DUT.RAM.mem_array[10] = 32'h00000FE0;
                     
   //Precarga ROM algoritmo1
  DUT.INSmemory.mem_array[0] = 32'h8C000000;
  DUT.INSmemory.mem_array[1] = 32'h8C020008;
  DUT.INSmemory.mem_array[2] = 32'h8C040009;
  DUT.INSmemory.mem_array[3] = 32'h00441020;
  DUT.INSmemory.mem_array[4] = 32'h00401824;
  DUT.INSmemory.mem_array[5] = 32'h8C05000A;
  DUT.INSmemory.mem_array[6] = 32'h00A03825;
  DUT.INSmemory.mem_array[7] = 32'h8C060002;
  DUT.INSmemory.mem_array[8] = 32'h00E63825;
  DUT.INSmemory.mem_array[9] = 32'h0007502A;
  DUT.INSmemory.mem_array[10] = 32'h00E0582A;
  DUT.INSmemory.mem_array[11] = 32'h201FFFFF;
  DUT.INSmemory.mem_array[12] = 32'h1007270F;
  DUT.INSmemory.mem_array[13] = 32'h0800000F;
   DUT.INSmemory.mem_array[14] = 32'h10000000;
   DUT.INSmemory.mem_array[15] = 32'h0800000E; 
   /*
   //Precarga ROM Algoritmo valor mas pequeño
   DUT.INSmemory.mem_array[0] = 32'h00000820;
   DUT.INSmemory.mem_array[1] = 32'h20020009;
   DUT.INSmemory.mem_array[2] = 32'h8C230000;
   DUT.INSmemory.mem_array[3] = 32'h20210001;
   DUT.INSmemory.mem_array[4] = 32'h8C240000;
   DUT.INSmemory.mem_array[5] = 32'h0083282A;
   DUT.INSmemory.mem_array[6] = 32'h10A00001;
  DUT.INSmemory.mem_array[7] = 32'h00801820;
  DUT.INSmemory.mem_array[8] = 32'h10220001;
  DUT.INSmemory.mem_array[9] = 32'h08000003;
  DUT.INSmemory.mem_array[10] = 32'hAC230004;
  DUT.INSmemory.mem_array[11] = 32'h0800000B;
   
   
   */
   /*
  // DUT.INSmemory.mem_array[0] = 32'h8C020003;//LW $2 3($0) 
   DUT.INSmemory.mem_array[1] = 32'h00201020;//add $2,$1,$0  
   DUT.INSmemory.mem_array[2] = 32'h00402820;//add $5,$2,$0
   DUT.INSmemory.mem_array[3] = 32'h00413022;//SUB  $6,$2,$1
   
   DUT.INSmemory.mem_array[4] = 32'h00413820;//ADD $7,$2,$1

   
   /*
   //Precarga del registro 0 con el valor 0
   DUT.Reg_Bank0.RB[0] = 32'h00000000;

   //Precarga RAM
   DUT.RAM.mem_array[0] = 32'h000000A0;
   DUT.RAM.mem_array[1] = 32'h00000008;
   DUT.RAM.mem_array[2] = 32'h00000005;
   DUT.RAM.mem_array[3] = 32'h0000000A;
   DUT.RAM.mem_array[4] = 32'h00000007;
   DUT.RAM.mem_array[5] = 32'h00000009;
   DUT.RAM.mem_array[6] = 32'h00000008;
   DUT.RAM.mem_array[7] = 32'h00000004;
   DUT.RAM.mem_array[8] = 32'h0000000F;
   DUT.RAM.mem_array[9] = 32'h0000000A;
                     
                      
   //Precarga ROM
    DUT.INSmemory.mem_array[0] = 32'h00000820;
UT.INSmemory.mem_array[1] = 32'h20020009;
   DUT.INSmemory.mem_array[2] = 32'h8C230000;
   DUT.INSmemory.mem_array[3] = 32'h20210001;
   DUT.INSmemory.mem_array[4] = 32'h8C240000;
   DUT.INSmemory.mem_array[5] = 32'h0083282A;
   DUT.INSmemory.mem_array[6] = 32'h10A00001;
   DUT.INSmemory.mem_array[7] = 32'h00801820;
   DUT.INSmemory.mem_array[8] = 32'h10220001;
   DUT.INSmemory.mem_array[9] = 32'h08000003;
   DUT.INSmemory.mem_array[10] = 32'hAC230004;
   DUT.INSmemory.mem_array[11] = 32'h0800000B;
   
   
   
   
/*
ADDI instruction
   DUT.INSmemory.mem_array[0] = 32'h20010019;
   DUT.INSmemory.mem_array[1] = 32'h20010019;
   DUT.INSmemory.mem_array[2] = 32'h20010019;
   DUT.INSmemory.mem_array[3] = 32'h20010019;
   */
   /*
   ADD instruction
   DUT.INSmemory.mem_array[0] = 32'h00410020;
   DUT.INSmemory.mem_array[1] = 32'h00410020; 
   DUT.INSmemory.mem_array[2] = 32'h00410020;
   DUT.INSmemory.mem_array[3] = 32'h00410020;
 */
   /*
   //codigo realizado para la verificacion de cada instruccion
   DUT.Reg_Bank0.RB[0] = 32'h00000000;
   DUT.RAM.mem_array[1] = 32'h0000000A;
   DUT.RAM.mem_array[0] = 32'h000000FC;
   DUT.INSmemory.mem_array[0] = 32'h8C010000; 
   DUT.INSmemory.mem_array[4] = 32'h8C020001;
   DUT.INSmemory.mem_array[8] = 32'h00411820;
   DUT.INSmemory.mem_array[12] = 32'h0041202A;
   DUT.INSmemory.mem_array[16] = 32'h00412824;
   DUT.INSmemory.mem_array[20] = 32'h00413025;
   DUT.INSmemory.mem_array[24] = 32'h00413822;
   ////////////////////////////////////////////
   DUT.INSmemory.mem_array[28] = 32'h00414027;//NOR
   DUT.INSmemory.mem_array[32] = 32'h20090009;//ADDI
   DUT.INSmemory.mem_array[36] = 32'h3400000a;//ORI
   DUT.INSmemory.mem_array[40] = 32'h10000000;//BEQ
   DUT.INSmemory.mem_array[44] = 32'hAC030003;//SW
   DUT.INSmemory.mem_array[48] = 32'h0BFFFFF6;//JUMP
   */

 end
  
endmodule 