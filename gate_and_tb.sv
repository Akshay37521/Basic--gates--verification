

interface and_bus;
logic a;
logic b;
logic c;
endinterface

module gate_and_tb;
and_bus vif();
gate_and dut(vif.a, vif.b, vif.c);

class trans_and;
rand bit a;
rand bit b;
bit c;
endclass

class gen_and;
trans_and p1;
function trans_and run();
  p1 = new();
  p1.randomize();
   return p1;
endfunction
endclass

class driver_and;
virtual and_bus vif;
task run(trans_and p1);
 vif.a = p1.a;
 vif.b = p1.b;
endtask
endclass
gen_and g;
driver_and d;
trans_and t;

initial begin
  g= new();
  d = new();
  d.vif = vif;
  repeat(10) begin
   t = g.run();
   d.run(t);
   #5;
  end
end

initial begin
$monitor("t=%0t,a=%b,b=%b,c=%b",$time,vif.a,vif.b,vif.c);
#100 $finish;
end
endmodule

   

