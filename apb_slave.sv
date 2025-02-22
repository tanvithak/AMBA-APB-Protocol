module apb_design(

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

 typedef enum logic [1:0] {IDLE,SETUP,ACCESS}state; 
 state ns,cs;

 always_ff@(posedge PCLK or negedge PRESETn)
  begin
   if(!PRESETn)
    cs <= IDLE;
   else
    cs <= ns;
  end

 //NEXT STATE LOGIC
 always_comb
  begin
   ns = IDLE;
   unique case(cs)
    IDLE   : begin
              if(PSEL)
               ns = SETUP;
              else
               ns = ACCESS;
             end
    SETUP  : begin
              ns = ACCESS;
             end
    ACCESS : begin
              if(PREADY)
               begin
                if(!PSEL)
                 ns = IDLE;
                else
                 ns = SETUP;
               end
              else
               ns = ACCESS;
             end    
   endcase
  end

 always_ff@(posedge CLK, negedge PRESETn)
  begin
   if(!PRESETn)
    PRDATA <= 0;
   else
    begin
     if(cs==ACCESS)
      begin
       if(PWRITE)
         mem[PADDR] <= PWDATA;
       else
        PRDATA <= mem[PADDR];
      end
    end
  end

endmodule
