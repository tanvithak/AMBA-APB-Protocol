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

endclass
    
