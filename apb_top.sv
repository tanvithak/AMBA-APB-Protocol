`include "apb_test.sv"
`include "apb_if.sv"

module top;
  bit clk = 0;  
  bit reset;

  always #5 clk = ~clk; 

  initial begin
    reset = 0;
    #20 reset = 1;  
    $display("[TOP] Reset asserted");
  end
 
  apb_if a1(clk, reset);

  test t1;

  initial begin
    $display("[TOP] Starting the test...");
    t1 = new(a1);
    t1.run();
    $display("[TOP] Test completed.");
    $finish;
  end

  apb_design dut1 (
    .PCLK(a1.PCLK),
    .PRESETn(a1.PRESETn),
    .PSEL(a1.PSEL),
    .PENABLE(a1.PENABLE),
    .PWRITE(a1.PWRITE),
    .PADDR(a1.PADDR),
    .PWDATA(a1.PWDATA),
    .PRDATA(a1.PRDATA),
    .PREADY(a1.PREADY)
  );

endmodule
