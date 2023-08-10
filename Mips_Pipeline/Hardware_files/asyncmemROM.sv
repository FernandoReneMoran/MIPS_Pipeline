module asyncmemROM(
/////////INPUTS/////////////////////////////
input  logic [31:0]raddr,   //Read address
input  logic [31:0]waddr,   //Write address
input  logic [31:0]Data_in, //Data input
input  logic wen,                 //Write enable
input  logic ren,

////////OUTPUTS////////////////////////////
output logic [31:0]data_out
);

logic [31:0] mem_array [0:1023];

  always@(*) 
        begin
            if (wen)
                mem_array[waddr]= Data_in;
        end
  always_comb data_out = ren ? mem_array[raddr] : 'Z;
//(romaddr>>2)
endmodule