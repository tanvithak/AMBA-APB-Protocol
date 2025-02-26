class apb_scoreboard;
 mailbox mon2sb;
 bit [31:0] mem[64];

 function new(mailbox mon2sb);
  this.mon2sb = mon2sb;
  foreach(mem[i])
    mem[i] = 32'h00;
 endfunction

 task main;
  apb_trans tr;
  forever
   begin
    #50;
    mon2sb.get(tr);
    $display("Scoreboard Done");
   end
 endtask

endclass
