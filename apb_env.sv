`include "apb_trans.sv"
import apb_pkg::*;

`include "apb_if.sv"
`include "apb_gen.sv"
`include "apb_drv.sv"
`include "apb_mon.sv"
`include "apb_scoreboard.sv"

class apb_env;

 apb_gen gen;
 apb_drv drv;
 apb_mon mon;
 apb_scoreboard sb;

 mailbox #(apb_trans) gen2drv;
 mailbox #(apb_trans) mon2sb;

 virtual apb_if vif;

 function new(virtual apb_if vif);
  this.vif = vif;
  gen2drv = new();
  mon2sb = new();

  gen = new(gen2drv);
  drv = new(vif, gen2drv);
  mon = new(vif, mon2sb);
  sb  = new(mon2sb);
 endfunction

 task pre_test();
  drv.reset();
 endtask

 task test();
  gen.main();

  fork
   drv.main();
   mon.main();
  join_any

  sb.main();
 endtask

 task run();
  pre_test();
  test();
  $finish;
 endtask

endclass
