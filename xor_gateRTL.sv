module xor_gate(a,b,c);
input  [2:0] a;
input  [2:0] b;
output [2:0] c;

assign c = a ^ b;

endmodule

