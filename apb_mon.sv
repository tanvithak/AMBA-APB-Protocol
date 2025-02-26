class apb_mon;
  virtual apb_if vif;
  mailbox mon2sb;

  function new(virtual apb_if vif, mailbox mon2sb);
    this.vif = vif;
    this.mon2sb = mon2sb;
  endfunction

  task main;
    forever
      begin
        apb_trans tr;
        tr = new();
        wait(vif.PRESETn);

        @(posedge vif.MON_MP.PCLK);
        @(posedge vif.MON_MP.PCLK);
        tr.PADDR = vif.MON_MP.mon_cb.PADDR;
        tr.PWRITE = vif.MON_MP.mon_cb.PWRITE;
        tr.PENABLE = vif.MON_MP.mon_cb.PENABLE;
        tr.PSEL = vif.MON_MP.mon_cb.PSEL;

        if(vif.MON_MP.mon_cb.PWRITE)
          tr.PWDATA = vif.MON_MP.mon_cb.PWDATA;

        if(!vif.MON_MP.mon_cb.PWRITE)
          tr.PRDATA = vif.MON_MP.mon_cb.PRDATA;
            
        mon2sb.put(tr);

        $display("Monitor done");
      end
  endtask

endclass
            
