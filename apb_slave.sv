/* Slave block

1. To get all the inputs and sample them
2. According to PWRITE signal, perform read or write operation
3. Generate PREADY signal.
*/

module apb_slave(
 input logic PCLK,
 input logic PRESETn,
 input logic PSEL,
 input logic PENABLE,
 input logic [31:0] PADDR,
 input logic [31:0] PWDATA,
 input logic PWRITE,
 output logic [31:0] PRDATA,
 output logic PREADY,
 output logic PSLVERR);

 parameter n = 5;
 logic [0:(2**n)-1] mem[logic [31:0]];

 always_ff@(posedge PCLK)
  begin
   if(!PRESETn)
    begin
     PRDATA <= 0;
     PREADY <= 0;
    end
   else if(PSEL && PENABLE)
    begin
     PREADY <= 1;
     if(PWRITE)
      mem[PADDR] <= PWDATA;
     else
      PRDATA <= mem[PADDR];
    end
   else
    PREADY <= 0;
  end


endmodule
