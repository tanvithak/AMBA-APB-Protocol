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

 logic [31:0] mem [0:2^(32)-1];//256 depth memory element with 32 bit data size.
 logic transfer;

 typedef enum logic [1:0] {IDLE,SETUP,ACCESS}state; 
 state ns,cs;
 
 always_ff@(posedge PCLK or negedge PRESETn)
  begin
   if(!PRESETn)
    cs <= IDLE;
   else
    begin
     cs <= ns;
    end
  end

  always_comb 
   begin
    if(cs == ACCESS && PENABLE) // A valid transfer occurs when PENABLE is high during ACCESS
      transfer = 1'b1;
    else if(cs == IDLE && PSEL) // In IDLE state, the next state will be SETUP if PSEL is active
      transfer = 1'b1;
    else
      transfer = 1'b0;
   end

 //NEXT STATE LOGIC
 always_comb
  begin
   ns = IDLE;
   unique case(cs)
    IDLE   : begin
              if(transfer)
               ns = SETUP;
              else
               ns = IDLE;
             end
    SETUP  : begin
              ns = ACCESS;
             end
    ACCESS : begin
              if(PREADY)
               begin
                if(transfer)
                 ns = SETUP;
                else
                 ns = IDLE;
               end
              else
               ns = ACCESS;
             end    
   endcase
  end

 always_comb
  begin
   unique case(cs)
    IDLE   : {mem[PADDR], PRDATA} = {mem[PADDR], PRDATA};
    SETUP  : {mem[PADDR], PRDATA} = {mem[PADDR], PRDATA};
    ACCESS : begin
              if(PWRITE)
                mem[PADDR] = PWDATA;
              else
                PRDATA = mem[PADDR];
             end
   endcase
  end


 //PREADY block
 always_ff@(posedge PCLK, negedge PRESETn)
  begin
   if(!PRESETn)
    PREADY <= 0;
   else
    begin
     if(cs==SETUP && PWRITE)
      PREADY <= 1'b1;
     else if(cs == ACCESS && ~PWRITE)
      begin
       if( ~( $isunknown(PRDATA) ) )
        PREADY <= 1'b1;
      end
     else
      PREADY <= 1'b0;
    end
  end

endmodule
