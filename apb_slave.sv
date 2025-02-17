module apb_slave(

 input logic PCLK,
 input logic PRESETn,
 input logic PSEL,
 input logic PENABLE,
 input logic PWRITE,
 input logic [31:0] PADDR,
 input logic [31:0] PWDATA,

 output logic [31:0] PRDATA,
 output logic PREADY
 );

 logic [31:0] mem [0:255];//256 depth memory element with 32 bit data size.



endmodule
