`include "apb_trans.sv"
import apb_pkg::*;

class apb_gen;
  apb_trans tr;
  mailbox #(apb_trans) gen2drv;

  function new(mailbox #(apb_trans) gen2drv);
    this.gen2drv = gen2drv;
  endfunction

  task main();
    $display("[GEN] Generator started...");
    repeat(100)
      begin
        tr = new();
        tr.randomize();
        if(!tr.randomize())
         $fatal("Generator : Randomization failed");
        gen2drv.put(tr);
        $display("[GEN] Sent transaction: PADDR=%h, PWRITE=%b", tr.PADDR, tr.PWRITE);
      end
    $display("[GEN] Generator Done");
  endtask
endclass
