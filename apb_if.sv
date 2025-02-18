interface apb_if(input logic PCLK, PRESETn);
  logic [31:0] PADDR;
  logic [31:0] PWDATA;
  logic PWRITE;
  logic PSEL;
  logic PENABLE;

  logic [31:0] PRDATA;
  logic PREADY;

  //DRIVER CLOCKING BLOCK
  clocking drv_cb@(posedge PCLK);
    default input #1 output #1;
    output PADDR;
    output PWDATA;
    output PWRITE;
    output PSEL;
    output PENABLE;

    input PRDATA;
    input PREADY;
  endclocking

  //MONITOR CLOCKING BLOCK
  clocking mon_cb@(posedge PCLK);
    default input #1 output #1;
    input PADDR;
    input PWDATA;
    input PWRITE;
    input PSEL;
    input PENABLE;
    input PRDATA;
    input PREADY;
  endclocking

  //MODPORTS
  modport DRV_MP(clocking drv_cb, input PCLK,PRESETn);
  modport MON_MP(clocking mon_cb, input PCLK,PRESETn);

endinterface
    
  
