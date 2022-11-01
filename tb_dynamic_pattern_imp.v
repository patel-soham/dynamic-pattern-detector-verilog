`include "dynamic_pattern_imp.v"
module tb;

parameter BITS=8; 

reg clk, rst, valid, in;
reg [BITS-1 : 0] pattern;
wire out;


dyn_pattern_imp # (.BITS(BITS)) u0 (.clk(clk), .rst(rst), .valid(valid), .in(in), .out(out), .pattern(pattern));

always #1 clk = ~clk;

initial begin
	clk = 0;
	valid = 0;
	in = 0;
	pattern = 0;

	rst = 1;
	repeat (5) @ (posedge clk);
	rst = 0;

	pattern = $random;
	valid = 1;
	repeat (300) begin
		in = $random;
		@ (posedge clk);
	end
	valid = 0;

	rst = 1;
	repeat (10) @ (posedge clk);
	rst = 0;

	repeat (5) @ (posedge clk);
	$finish;
end

endmodule 
