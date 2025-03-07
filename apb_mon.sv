`include "apb_trans.sv"
import apb_pkg::*;
class apb_mon;
  virtual apb_if vif;
  mailbox #(apb_trans) mon2sb;

  function new(virtual apb_if vif, mailbox #(apb_trans) mon2sb);
    this.vif = vif;
    this.mon2sb = mon2sb;
  endfunction

  task main;
    apb_trans tr; 
    $display("[MON] Monitor started...");
    
    repeat(100) begin
      tr = new();
      wait(vif.PRESETn);

      @(posedge vif.MON_MP.PCLK);
      @(posedge vif.MON_MP.PCLK);
      
      tr.PADDR   = vif.MON_MP.mon_cb.PADDR;
      tr.PWRITE  = vif.MON_MP.mon_cb.PWRITE;
      tr.PENABLE = vif.MON_MP.mon_cb.PENABLE;
      tr.PSEL    = vif.MON_MP.mon_cb.PSEL;

      if (vif.MON_MP.mon_cb.PWRITE)
        tr.PWDATA = vif.MON_MP.mon_cb.PWDATA;
      else
        tr.PRDATA = vif.MON_MP.mon_cb.PRDATA;
          
      mon2sb.put(tr);
      $display("[MON] Captured: PADDR=%h, PWRITE=%b, PWDATA=%b, PRDATA = %b", tr.PADDR, tr.PWRITE, tr.PWDATA, tr.PRDATA);
    end
  endtask

endclass
