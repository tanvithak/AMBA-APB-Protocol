`include "apb_env.sv"

class test;
  apb_env env;
  virtual apb_if vif;
  int num_trans = 10; // Expected number of transactions

  function new(virtual apb_if vif);
    this.vif = vif;
    env = new(vif);
  endfunction

  task run();
    $display("[TEST] Simulation started...");
    env.run();

    fork
      begin
        wait(env.sb.trans_count >= num_trans); 
        $display("[TEST] All transactions completed. Ending simulation.");
        $finish;
      end

      begin
        #5000ns; 
        $display("[TEST] Simulation Timeout! Ending.");
        $stop;
      end
    join_any;
  endtask
endclass
