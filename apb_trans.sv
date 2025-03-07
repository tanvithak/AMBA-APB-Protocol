package apb_pkg;
class apb_trans;
   rand bit PCLK;
   rand bit PRESETn;
   rand bit PSEL;
   rand bit PENABLE;
   rand bit PWRITE;
   rand bit [31:0] PADDR;
   rand bit [31:0] PWDATA;
   bit [31:0] PRDATA;
   bit PREADY;
   static bit [31:0] past_addrs[$];
   
   //constraint addr_range {PADDR >= 0; PADDR < 256;}

   function new();
     this.PCLK = 0;
     this.PRESETn = 0;
     this.PSEL = 0;
     this.PENABLE = 0;
     this.PWRITE = 0;
     this.PADDR = 0;
     this.PWDATA = 0;
     this.PRDATA = 0;
     this.PREADY = 0;
   endfunction

   function void post_randomize();
    if (PWRITE == 1) 
     begin
      past_addrs.push_back(PADDR); 
      if (past_addrs.size() > 100) 
       past_addrs.pop_front();
     end
    endfunction

    constraint read_addr{
        if (PWRITE == 1) {
            PADDR inside {[0:2^(32)-1]}; 
        } else {
            if (past_addrs.size() > 0) { 
                PADDR inside {past_addrs}; 
            }
        }
    }
endclass
endpackage
