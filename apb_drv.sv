class apb_drv;
  virtual apb_intf vif;
  mailbox gen2drv;
  transaction tr;

  function new(virtual apb_intf vif, mailbox gen2drv);
    this.vif = vif;
    this.gen2drv = gen2drv;
  endfunction

  task reset;
    wait(!vif.PRESETn);
    $display("Driver: Reset task");
    vif.DRV_MP.drv_cb.PWRITE <= 0;
    vif.DRV_MP.drv_cb.PSEL <= 0;
    vif.DRV_MP.drv_cb.PADDR <= 0;
    vif.DRV_MP.drv_cb.PWDATA <= 0;
    vif.DRV_MP.drv_cb.PENABLE <= 0;
    wait(vif.PRESETn);
  endtask

  task drive;
    repeat(5)
      begin
        gen2drv.get(tr);
        write();
      end
    repeat(5)
      begin
        gen2drv.get(tr);
        read();
      end
  endtask

  task write;
    vif.DRV_MP.drv_cb.PSEL <= 1;
    @(posedge vif.DRV_MP.clk);
    vif.DRV_MP.drv_cb.PENABLE <= 0;
    vif.DRV_MP.drv_cb.PWRITE <= 1;
    vif.DRV_MP.drv_cb.PADDR <= tr.PADDR;
    vif.DRV_MP.drv_cb.PWDATA <= tr.PWDATA;
    @(posedge vif.DRV_MP.clk);
    vif.DRV_MP.drv_cb.PENABLE <= 1;
    vif.DRV_MP.drv_cb.PWRITE <= 1;
    vif.DRV_MP.drv_cb.PADDR <= tr.PADDR;
    vif.DRV_MP.drv_cb.PWDATA <= tr.PWDATA;
  endtask

  task read;
    vif.DRV_MP.drv_cb.PSEL <= 1;
    @(posedge vif.DRV_MP.clk);
    vif.DRV_MP.drv_cb.PENABLE <= 0;
    vif.DRV_MP.drv_cb.PWRITE <= 0;
    vif.DRV_MP.drv_cb.PADDR <= tr.PADDR;
    @(posedge vif.DRV_MP.clk);
    vif.DRV_MP.drv_cb.PENABLE <= 1;
    vif.DRV_MP.drv_cb.PWRITE <= 0;
    vif.DRV_MP.drv_cb.PADDR <= tr.PADDR;  
    tr.PRDATA <= vif.DRV_MP.drv_cb.PRDATA;
  endtask

  task main;
    @(posedge vif.DRV_MP.clk);
    drive();
  endtask

endclass
    
    
