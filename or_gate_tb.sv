

interface or_gatebus;
logic a;
logic b;
logic c;
endinterface

module or_tb;
or_gatebus vif();
or_gate dut(vif.a,vif.b,vif.c);
class trans_or;
rand bit a;
rand bit b;

endclass

class gen_or;
trans_or p1;
function trans_or run();
  p1 = new();
  if(!p1.randomize())
    $fatal("randomization not happen!");
  return p1;
endfunction
endclass

class driver_or;
virtual or_gatebus vif;
task run(trans_or p1);
 vif.a = p1.a;
 vif.b = p1.b;
endtask
endclass

initial begin
 gen_or g1;
 driver_or d1;
 trans_or p1;
 g1 = new();
 d1 = new();
 d1.vif = vif;
 repeat(20) begin
  p1 = g1.run();
  d1.run(p1);
 #5;
 if(vif.c !=(vif.a | vif.b))
   $display("ERROR: t=%0t,a=%b,b=%b,expected=%b,got = %b",$time,vif.a,vif.b,(vif.a|vif.b),vif.c);
else
  $display("PASS: t=%0t,a=%b,b=%b,expected=%b,got = %b",$time,vif.a,vif.b,(vif.a|vif.b),vif.c);
 

end
end

initial begin
$monitor("t=%0t,a=%b,b=%b,c=%b",$time,vif.a,vif.b,vif.c);
#100 $finish;
end
endmodule
