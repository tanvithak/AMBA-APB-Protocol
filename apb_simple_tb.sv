module simple_tb();
  logic clk;
  logic rstn;
  logic [31:0] addr;
  logic [31:0] wr_data;
  logic wr;
  logic sel;
  logic enable;

  logic ready;
  logic [31:0] out_data;

  apb_design DUT( clk,rstn,sel, enable,wr,addr,wr_data,out_data,ready);

  // Clock generation
  initial begin
    forever #5 clk = !clk;
  end

  // Initialization
  task initialise;
   begin
     clk = 0;
     rstn = 0;
     {addr, wr_data, wr, sel, enable} = 0;
   end
  endtask

  // Reset Task
  task reset;
   begin
     rstn = 0;
     @(posedge clk);  // Wait for clock edge
     rstn = 1;        // Release reset on the next clock cycle
   end
  endtask

  // Start Task
  task start;
   begin
     sel = 1;
     wr = 0;
     enable = 0;
   end
  endtask

  // Write Task
  task write;
    input [31:0] data_in;
    input [31:0] addr_in;
   begin
     @(posedge clk);
     enable = 0;      // Ensure enable is low initially
     wr = 1;
     wr_data = data_in;
     addr = addr_in;
     @(posedge clk);   // Wait for the next clock edge before setting enable
     enable = 1;      // Assert enable for the next clock edge
     @(posedge clk);   // Wait for the DUT to react (optional)
     enable = 0;      // Deassert enable after the transfer
   end
  endtask

  // Read Task
  task read;
    input [31:0] addr_in;
   begin
     @(posedge clk);
     wr = 0;
     addr = addr_in;
     enable = 1;      // Assert enable to start the read transfer
     @(posedge clk);   // Wait for the DUT to respond (optional)
     enable = 0;      // Deassert enable after the read operation
   end
  endtask

  // Main Test Procedure
  initial begin
    initialise;
    reset;
    start;

    write(12, 22);
    write(13, 23);
    write(14, 24);
    write(15, 25);
    write(16, 26);

    read(23);
    read(22);
    read(24);
    read(25);
    read(22);
    read(26);
    
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    $stop;  // End the simulation
  end
endmodule
