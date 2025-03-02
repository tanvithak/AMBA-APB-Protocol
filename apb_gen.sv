class apb_gen;
  rand apb_trans tr;
  mailbox gen2drv;

  function new(mailbox gen2drv);
    this.gen2drv = gen2drv;
  endfunction

  task main();
    repeat(10)
      begin
        tr = new();
        tr.randomize();
        gen2drv.put(tr);
      end
    $display(  "Generator Done" );
  endtask
endclass
