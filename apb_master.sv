module apb_master(

 input logic [31:0]PRDATA,
 input logic PRESETn,
 input logic PCLK,
 input logic PREADY,

 output logic PSEL,
 output logic PENABLE,
 output logic [7:0]PADDR,
 output logic PWRITE,
 output logic [31:0]PWDATA);

 typedef enum logic [1:0] {IDLE,SETUP,ENABLE}state; 
 state ns,cs;

 always_ff@(posedge PCLK or negedge PRESETn)
  begin
   if(!PRESETn)
    cs <= IDLE;
   else
    cs <= ns;
  end


 //outputs of FSM
 always_comb
  begin
   {PSEL,PENABLE} = 2'b00;
   case(cs)
    IDLE   : begin
              PSEL = 0;
              PENABLE = 0;
             end
    SETUP  : begin
              PSEL = 1;
              PENABLE = 0;
             end
    ENABLE : begin
              PSEL = 1;
              PENABLE = 1;
             end
   endcase
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
               ns = ENABLE;
             end
    SETUP  : begin
              ns = ENABLE;
             end
    ENABLE : begin
              if(PREADY)
               ns = IDLE;
              else
               ns = ENABLE;
             end    
   endcase
  end

endmdodule
