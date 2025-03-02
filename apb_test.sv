`include "apb_env.sv"
program test(apb_if vif);
 apb_env env;
 initial
  begin
   env = new(vif);
   env.run();
  end
endprogram
