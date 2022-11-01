`include "dynamic_pattern_exp.v"
module tb;

reg clk, valid, rst, in;
wire out;

dyn_pattern_exp u0 (.clk(clk), .rst(rst), .valid(valid), .in(in), .out(out));

always #1 clk =~clk;

initial begin
	clk = 0;
	valid = 0;
	in = 0;

	rst = 1;
	repeat (5) @ (posedge clk);
	rst = 0;

	repeat (5) @ (posedge clk);
	valid = 1;

	repeat (200) begin 
		in = $random;
		@(posedge clk);
	end

	$finish;
end

endmodule
	
