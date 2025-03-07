`include "apb_trans.sv"
import apb_pkg::*;
class apb_scoreboard;
 int trans_count = 0;
 mailbox #(apb_trans) mon2sb;
 bit [31:0] mem[64];
 int max_trans;

 function new(mailbox #(apb_trans)mon2sb, int max_trans=100);
  this.mon2sb = mon2sb;
  foreach(mem[i])
    mem[i] = 32'h00;
  this.max_trans = max_trans;
 endfunction

 task main;
  $display("[SB] Scoreboard started...");
  repeat(100)
   begin
    apb_trans tr;
    mon2sb.get(tr);
    trans_count++;
    $display("[SB] Received transaction %0d: PADDR=%h, PWRITE=%b",
               trans_count, tr.PADDR, tr.PWRITE);
    if (tr.PWRITE) 
     begin
      mem[tr.PADDR] = tr.PWDATA;
      $display("[SB] WRITE: Stored %h at address %h", tr.PWDATA, tr.PADDR);
     end 
    else 
     begin
      if (mem[tr.PADDR] !== tr.PRDATA) 
       $display("[SB] READ MISMATCH at address %h: Expected %h, but got %h",tr.PADDR, mem[tr.PADDR], tr.PRDATA);
      else 
       $display("[SB] READ MATCH at address %h: Value = %h", tr.PADDR, tr.PRDATA);
     end
      if (trans_count >= max_trans) begin
        $display("[SB] Reached maximum transactions. Stopping.");
        $finish;
     end
   end
 endtask

endclass
