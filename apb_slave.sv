/* Slave block

1. To get all the inputs and sample them
2. According to PWRITE signal, perform read or write operation
3. Generate PREADY signal.
*/

module apb_slave #(parameter n = 5)(
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

 logic [31:0] mem[0:(2**N)-1];

 always_ff@(posedge PCLK)
  begin
   if (!PRESETn) 
    begin
      PRDATA <= 0;
      PREADY <= 0;
      PSLVERR <= 0;
    end 
   else 
    begin
      PREADY <= 0;
      PSLVERR <= 0;

      if (PSEL && PENABLE) 
       begin
        PREADY <= 1; // zero-wait state

        if (PWRITE) 
         begin
          if (PADDR < (2**N)) // valid address check
            mem[PADDR] <= PWDATA;
          else
            PSLVERR <= 1;
         end 
        else 
         begin
          if (PADDR < (2**N))
            PRDATA <= mem[PADDR];
          else
            PSLVERR <= 1;
        end
      end
    end
  end


endmodule
