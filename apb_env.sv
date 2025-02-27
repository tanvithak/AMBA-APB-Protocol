class apb_env;

 generator gen;
 driver driv;
 monitor mon;
 scoreboard sb;

 mailbox gen2drv;
 mailbox mon2sb;

 virtual apb_if vif;

 function new(virtual apb_if vif);
  this.apb_vif = apb_vif;
  gen2drv = new();
  mon2sb = new();

  gen = new(gen2drv);
  drv = new(vif, gen2drv);
  mon = new(vif, mon2sb);
  sb  = new(mon2sb);
 endfunction

 task pre_test();
  drv_reset();
 endtask

 task test();
  gen.main();

  fork
   drv.main();
   mon.main();
  join_any

  sb_main();
 endtask

 task run();
  pre_test();
  test();
  $finish;
 endtask

endclass
