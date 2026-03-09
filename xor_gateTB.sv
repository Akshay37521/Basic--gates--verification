interface xor_bus;
logic [2:0] a;
logic [2:0] b;
logic [2:0] c;
endinterface


module xor_tb;

xor_bus inf();
xor_gate dut(inf.a, inf.b, inf.c);
  // transaction
class xor_trans;

rand bit [2:0] a;
rand bit [2:0] b;

endclass



mailbox #(xor_trans) mbx = new();




// generator
class xor_gen;

mailbox #(xor_trans) mbx;

function new(mailbox #(xor_trans) mbx);
 this.mbx = mbx;
endfunction

task run();

xor_trans t;

  repeat(200) begin

 t = new();

 assert(t.randomize());

 mbx.put(t);

end

endtask

endclass



// driver
class xor_driver;

virtual xor_bus inf;
mailbox #(xor_trans) mbx;

function new(mailbox #(xor_trans) mbx);
 this.mbx = mbx;
endfunction

task run();

xor_trans t;

  repeat(200) begin

 mbx.get(t);

 inf.a = t.a;
 inf.b = t.b;

 #5;
  if(inf.c != (inf.a ^ inf.b))
  $display("FAIL: t=%0t a=%b b=%b expected=%b got=%b",
           $time,inf.a,inf.b,(inf.a^inf.b),inf.c);

 else
  $display("PASS: t=%0t a=%b b=%b c=%b",
           $time,inf.a,inf.b,inf.c);


end

endtask

endclass



xor_gen g1;
xor_driver d1;



initial begin

 g1 = new(mbx);
 d1 = new(mbx);

 d1.inf = inf;

 fork
  g1.run();
  d1.run();
 join

end



// checker
initial begin
  #250;
  $finish;
end

 




/*initial begin
 $monitor("t=%0t a=%b b=%b c=%b",$time,inf.a,inf.b,inf.c);
end*/

endmodule
