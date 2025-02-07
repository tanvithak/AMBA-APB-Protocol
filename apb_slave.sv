module apb_slave(

 input logic PCLK,
 input logic PRESETn,
 input logic PSEL,
 input logic PENABLE,
 input logic PWRITE,
 input logic [7:0] PADDR,
 input logic [31:0] PWDATA,

 output logic [31:0] PRDATA,
 output logic PREADY
 );

 logic [31:0] mem [0:255];

 always_ff@(posedge PCLK or negedge PRESETn)
  begin
   if(!PRESETn)
    begin
     PRDATA <= 32'b0;
     PREADY <= 1'b0;
    end
   else
    begin
     if({PSEL,PENABLE} = 2'b11)
       begin
               PREADY <= 1'b1;
               if(PWRITE)
                mem[PADDR] <= PWDATA;
               else
                PRDATA <= mem[PADDR];
        end
     else
      PREADY <= 1'b0;
    end
  end

endmodule
