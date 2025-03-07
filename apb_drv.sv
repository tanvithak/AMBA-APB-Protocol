`include "apb_trans.sv"
import apb_pkg::*;

class apb_drv;
  virtual apb_if vif;
  mailbox #(apb_trans) gen2drv;
  apb_trans tr;

  function new(virtual apb_if vif, mailbox #(apb_trans) gen2drv);
    this.vif = vif;
    this.gen2drv = gen2drv;
  endfunction

  task reset;
    wait(!vif.PRESETn);
    vif.DRV_MP.drv_cb.PWRITE  <= 0;
    vif.DRV_MP.drv_cb.PSEL    <= 0;
    vif.DRV_MP.drv_cb.PADDR   <= 0;
    vif.DRV_MP.drv_cb.PWDATA  <= 0;
    vif.DRV_MP.drv_cb.PENABLE <= 0;
    
    repeat(2) @(posedge vif.DRV_MP.PCLK);
    wait(vif.PRESETn);
  endtask

  task drive;
    repeat(100) begin
      gen2drv.get(tr); // Blocking, ensures transaction availability
      
      if (tr.PWRITE)
        write();
      else
        read();
    end
  endtask

  task write;
    vif.DRV_MP.drv_cb.PSEL   <= 1;
    vif.DRV_MP.drv_cb.PWRITE <= 1;
    vif.DRV_MP.drv_cb.PADDR  <= tr.PADDR;
    vif.DRV_MP.drv_cb.PWDATA <= tr.PWDATA;

    @(posedge vif.DRV_MP.PCLK);
    vif.DRV_MP.drv_cb.PENABLE <= 1;

    @(posedge vif.DRV_MP.PCLK);
    
    // Deassert control signals
    vif.DRV_MP.drv_cb.PSEL    <= 0;
    vif.DRV_MP.drv_cb.PENABLE <= 0;
    vif.DRV_MP.drv_cb.PWRITE  <= 0;

    $display("[DRV] WRITE: PADDR=%h, PWRITE=%b, PWDATA=%h", tr.PADDR, tr.PWRITE, tr.PWDATA);
  endtask

  task read;
    vif.DRV_MP.drv_cb.PSEL   <= 1;
    vif.DRV_MP.drv_cb.PWRITE <= 0;
    vif.DRV_MP.drv_cb.PADDR  <= tr.PADDR;

    @(posedge vif.DRV_MP.PCLK);
    vif.DRV_MP.drv_cb.PENABLE <= 1;

    @(posedge vif.DRV_MP.PCLK);
    tr.PRDATA = vif.DRV_MP.drv_cb.PRDATA;

    // Deassert control signals
    vif.DRV_MP.drv_cb.PSEL    <= 0;
    vif.DRV_MP.drv_cb.PENABLE <= 0;

    $display("[DRV] READ: PADDR=%h, PWRITE=%b, PRDATA=%h", tr.PADDR, tr.PWRITE, tr.PRDATA);
  endtask
  task main;
    @(posedge vif.DRV_MP.PCLK);
    drive();
  endtask
endclass
