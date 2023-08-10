module MIPS (
input logic clk,
input logic clr,
  output logic [31:0] alu
);

logic jump,branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite,RegDst,zero,EN_REG,comp,En_P,EN_CONTROL,MemWrite_MEM;
  logic [31:0]mux_s2,mux_s3,mux_s4,mux_s5,rom_addr,rom_out,r_data2,r_data1,mux2_in1,result_PC,mux5_in1,
shift2_out,mux4_in1,mux3_in1,conversion_momentanea,out_shift1,MuxForwardA,MuxForwardB,PC_in,prueba;
logic [4:0]mux_s1;
logic [7:0]alu_in;
logic [1:0]aluop,ForwardA,ForwardB;
logic [31:0] aluResult;

logic PCSrc,en_adder_bh;

assign alu = aluResult; 
  assign prueba =( PCSrc && !EN_REG)||jump;
//Registros para el pipeline
////////////////////////////////////////////////////////////////////////////////////
//IF/ID
  logic [31:0] pcn_ID,instruction_ID; 

always_ff @(posedge clk)
  pcn_ID <= result_PC; 
  
always_ff @(posedge clk)
  
  instruction_ID <= (prueba)? 32'h00000020:(EN_REG) ? instruction_ID: rom_out;

///  /
//ID/EX 
logic [31:0] pcn_EX,signExt_EX,readData1_EX,readData2_EX;
logic branch_EX,MemRead_EX,MemtoReg_EX,MemWrite_EX,ALUSrc_EX,RegWrite_EX;
logic [1:0] aluop_EX;
logic [5:0] function_EX;
  logic [4:0] writeAddres_EX,RS,RT,RDMuxO;

always_ff @(posedge clk)
	pcn_EX <= pcn_ID; 	 
  
always_ff @(posedge clk)
  writeAddres_EX <=(prueba) ? 1'b0: RDMuxO ;  

always_ff @(posedge clk)
  function_EX <=(EN_REG||prueba) ? 6'b0: instruction_ID[5:0]; 
  
always_ff @(posedge clk)
  RS <= (EN_REG||prueba) ? 5'b0:instruction_ID[25:21]; 
  
always_ff @(posedge clk)
  RT<= (EN_REG||prueba) ? 5'b0:instruction_ID[20:16]; 
 
always_ff @(posedge clk)
	signExt_EX <= mux2_in1; 

always_ff @(posedge clk)
  readData1_EX <= (clr) ? 32'b0: r_data1; 
 
always_ff @(posedge clk)
  readData2_EX <= (clr) ? 32'b0: r_data2; 
   
always_ff @(posedge clk)
  if(clr)
    branch_EX <= 0;
  else
	branch_EX <= branch;  
always_ff @(posedge clk)
  MemRead_EX <=(EN_REG) ? 1'b0: MemRead;
always_ff @(posedge clk)
    MemtoReg_EX <=(EN_REG) ? 1'b0: MemtoReg;
always_ff @(posedge clk)
	MemWrite_EX <=(EN_REG) ? 1'b0: MemWrite;
always_ff @(posedge clk)
  ALUSrc_EX <=  ALUSrc;
always_ff @(posedge clk)
  RegWrite_EX <= (EN_REG) ? 1'b0: RegWrite;
always_ff @(posedge clk)
    aluop_EX <= aluop;
  

////
//EX/MEM
logic [31:0] pcn_MEM, aluResult_MEM,readData2_MEM;
logic zero_MEM;
logic branch_MEM,MemRead_MEM,MemtoReg_MEM,RegWrite_MEM;
  logic [4:0] writeAddres_MEM;

  
always_ff @(posedge clk)
    pcn_MEM <= mux4_in1;

always_ff @(posedge clk)
	zero_MEM <= zero;

always_ff @(posedge clk)
	aluResult_MEM <= aluResult;
  
always_ff @(posedge clk)
	readData2_MEM <= readData2_EX;
  
always_ff @(posedge clk)
	writeAddres_MEM <= writeAddres_EX;
  
always_ff @(posedge clk)
	if(clr)
    branch_MEM <= 0;
  else
	branch_MEM <= branch_EX;
  
always_ff @(posedge clk)
  MemRead_MEM <= MemRead_EX;
always_ff @(posedge clk)
  MemtoReg_MEM <= MemtoReg_EX;
always_ff @(posedge clk)
  MemWrite_MEM <= MemWrite_EX;
always_ff @(posedge clk)
  RegWrite_MEM <= RegWrite_EX;
  
  
  
////
//MEM/WB 
logic [31:0] aluResult_WB,RAMDataOut_WB;
logic[4:0] writeAddres_WB;
logic MemtoReg_WB,RegWrite_WB;

always_ff @(posedge clk)
	aluResult_WB <= aluResult_MEM;
  
always_ff @(posedge clk)
	RAMDataOut_WB <= mux3_in1;
  
 
always_ff @(posedge clk)
  writeAddres_WB <= writeAddres_MEM;

always_ff @(posedge clk)
	MemtoReg_WB <= MemtoReg_MEM;
always_ff @(posedge clk)
  RegWrite_WB <= RegWrite_MEM;
//Fin de los registros 
////////////////////////////////////////////////////////////
control control_unit(
.opcode(instruction_ID[31:26]),
.jump(jump),
.branch(branch),
.MemRead(MemRead),
.MemtoReg(MemtoReg),
.MemWrite(MemWrite),
.ALUSrc(ALUSrc),
.RegWrite(RegWrite),
.RegDst(RegDst),
.ALUOp(aluop));

PC counter(
.clk(clk),
.clr(clr),
.data_in(PC_in),
.data_out(rom_addr),
.en(En_P));

Reg_Bank #(.WL(32),.AL(5))
Reg_Bank0(
	.clk(clk), 
	.wr_en(RegWrite_WB),
	.rd1_en(1'b1),
	.rd2_en(1'b1),
    .w_addr(writeAddres_WB), 
	.r_addr1(instruction_ID[25:21]),
	.r_addr2(instruction_ID[20:16]),
	.w_data(mux_s3),
	.r_data1(r_data1),
  .r_data2(r_data2),
  .rst(clr)
);

asyncmemROM 
INSmemory(
.raddr(rom_addr >> 2),
.waddr('0),
.Data_in('0),
.wen(1'b0),
.ren(1'b1),
.data_out(rom_out)
);

asyncmem 
RAM(.raddr(aluResult_MEM),
.waddr(aluResult_MEM),
.Data_in(readData2_MEM),
.wen(MemWrite_MEM),
.ren(MemRead_MEM),
.clk(clk),
.data_out(mux3_in1)
);

 sign extender(
.in(instruction_ID[15:0]),
.out(mux2_in1));

  shift_rJump #(.S(26))instr(
.in(instruction_ID[25:0]),
.out(out_shift1) );

shift_r #(.S(32)) jumpt(
.in(mux2_in1),
.out(shift2_out) );



alu m3(
.a(MuxForwardA),
.b(MuxForwardB),
.alu_in(alu_in),
.zero(zero),
.alu_out(aluResult));

alu_control M2(
.aluop(aluop_EX),
.instr(function_EX), 
.alu_in(alu_in));

mux_ #(.WL(5)) mux1 (
.in_0(instruction_ID[20:16]),
.in_1(instruction_ID[15:11]),
.sel(RegDst),
.out(mux_s1)
);
mux_  #(.WL(32)) mux2 (
.in_0(readData2_EX),
.in_1(signExt_EX),
.sel(ALUSrc_EX),
.out(mux_s2)
);
  
mux_  #(.WL(32)) mux3 (
.in_0(aluResult_WB),
.in_1(RAMDataOut_WB),
.sel(MemtoReg_WB),
.out(mux_s3)
);
mux_ #(.WL(32)) mux4(
.in_0(result_PC),
.in_1(mux4_in1),
.sel(PCSrc),
.out(mux_s4)
);
mux_ #(.WL(32)) mux5(
.in_0(mux_s4),
.in_1(conversion_momentanea),
.sel(jump),
.out(mux_s5)
);

adder PC(
.A(rom_addr),
  .B(32'd4),
  .result(result_PC),
  .en(en_adder_bh)
);

adder jump1(
.A(pcn_ID),
.B(shift2_out),
  .result(mux4_in1),
.en(en_adder_bh));

  
forward forward1(
.EXMEM_RegWrite(RegWrite_MEM) ,
.EXMEM_RegisterRd (writeAddres_MEM),
.IDEX_RegisterRs (RS),
.MEMWB_RegWrite (RegWrite_WB),
.MEMWB_RegisterRd (writeAddres_WB),
.IDEX_RegisterRt (RT),
.MemWrite_EX(MemWrite_EX),
///output//
.ForwardA (ForwardA),
.ForwardB (ForwardB));

Hazard hazard(
  .IDEX_MemRead(MemRead_EX),
.IDEX_RegisterRt(writeAddres_EX),
.IFID_RegisterRs(instruction_ID[25:21]),
.IFID_RegisterRt(instruction_ID[20:16]),
.PCSrc(branch),
.writeAddres_MEM(writeAddres_MEM),
.writeAddres_WB(writeAddres_WB),
.jump(jump),
.EX_MemWrite(MemWrite),
.ID_RegWrite(RegWrite),
///OUTPUTS//
///OUTPUTS//
.En_PC(En_P),
.EN_REG(EN_REG),
.EN_CONTROL(EN_CONTROL),
.Branch_Flush(en_adder_bh));
  
assign comp = (r_data1  == r_data2) ? 1'b1:1'b0;
  
assign PCSrc= branch && comp;
  
assign conversion_momentanea= {rom_addr[31:28],out_shift1};

  assign PC_in = (jump)? conversion_momentanea:(PCSrc)? mux4_in1:result_PC;
  
assign MuxForwardA= (ForwardA == 2'b01) ? (mux_s3) :( ForwardA == 2'b10) ? (aluResult_MEM) : (readData1_EX);
assign MuxForwardB= (ForwardB == 2'b01) ? (mux_s3) :( ForwardB == 2'b10) ? (aluResult_MEM) : (mux_s2);
  assign RDMuxO= (EN_CONTROL) ? 5'b0:mux_s1;
endmodule




