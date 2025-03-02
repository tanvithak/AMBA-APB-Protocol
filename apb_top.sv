//`include "apb_test.sv"
`include "apb_if.sv"

module top;
 bit clk;
 bit reset;

 always #5 clk = ~clk;

 initial
  begin
   reset = 0;
   #10 reset = 1;
  end

 apb_if a1(clk,reset);
 test t1(vif);

 apb_design dut1(a1.PCLK,a1.PRESETn,a1.PSEL,a1.PENABLE,a1.PWRITE,a1.PADDR,a1.PWDATA,a1.PRDATA,a1.PREADY);

endmodule
