module simple_tb();

  logic clk;
  logic clk1;
  logic rstn;
  logic [31:0] addr;
  logic [31:0] wr_data;
  logic wr;
  logic sel;
  logic enable;

  logic ready;
  logic [31:0] out_data;


  always 
    forever #5 clk = !clk;

  task initialise;
   begin
     clk = 0;
     rstn = 0;
     {addr,wr_data,wr,sel,enable} = 0;
   end
  endtask

  task reset;
   begin
     clk = 0;
     rstn = 0;
     @(posedge clk);
     #3;
     rstn = 1;
   end
  endtask

  task start;
   begin
    sel = 1;
   end
  endtask

  task write;
    input [31:0] data_in;
    input [31:0] addr_in;
    begin
      @(posedge clk);
      enable = 0;
      wr = 1;
      wr_data = data_in;
      addr = addr_in;
      @(posedge clk);
      enable = 1;
    end
  endtask

  task read;
    input [31:0] addr_in;
    begin
      @(posedge clk);
      wr = 0;
      addr = addr_in;
      enable = 1;
      @(posedge clk);
      enable = 0;
    end
  endtask

  initial
    begin
      initialise;
      reset;
      start;

      write(12,22);
      write(13,23);
      write(14,24);
      write(15,25);
      write(16,26);

      read(23);
      read(24);
      read(25);
      read(22);
      read(26);
      #2
      $stop;
    end
  
endmodule
