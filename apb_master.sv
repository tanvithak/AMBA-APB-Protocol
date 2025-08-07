/*Master Block

1. TO GENERATE PSEL AND PENABLE SIGNALS ACCORDING TO THE STATES 
2. MONITOR ITS ACTIVITY ACCORDING TO PREADY
3. FSM

*/
module apb_master(
 input logic PCLK,
 input logic PRESETn,

 output logic PENABLE,
 output logic PSEL,
 output logic [31:0] PADDR,
 output logic [31:0] PWDATA,
 output logic PWRITE,
 input logic [31:0] PRDATA,
 input logic PREADY,
 input logic PSLVERR);


 typedef enum logic [1:0] {IDLE,SETUP,ACCESS} state;

 state cs,ns;

 /* logic transfer;

 always_comb 
  begin
   if(cs == ACCESS && PENABLE) // A valid transfer occurs when PENABLE is high during ACCESS
    transfer = 1'b1;
   else if(cs == IDLE && PSEL) // In IDLE state, the next state will be SETUP if PSEL is active
    transfer = 1'b1;
   else
    transfer = 1'b0;
  end */

 always_ff@(posedge PCLK)
  begin
   if(!PRESETn)
    cs <= IDLE;
   else
    cs <= ns;
  end


always_comb
 begin
  ns = IDLE;
  unique case(cs)
   IDLE   : begin
             if(PSEL)
              ns = SETUP;
             else
              ns = IDLE;
            end
   SETUP  : ns = ACCESS;
   ACCESS : begin
             if(PREADY)
              ns = IDLE;
             else
              ns = ACCESS;
            end
  endcase
 end

always_comb
 begin
  unique case(cs)
   IDLE   : begin
             PSEL = 0;
             PENABLE = 0;
            end
   SETUP  : begin
             PSEL = 1;
             PENABLE = 0;
            end
   ACCESS : begin
             PSEL = 1;
             PENABLE = 1;
            end
  endcase
 end
endmodule
