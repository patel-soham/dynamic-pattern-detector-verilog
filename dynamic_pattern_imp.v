// Dynamic pattern detector implicit style fsm
module dyn_pattern_imp(clk, rst, valid, in, out, pattern);

// N bit pattern detector
parameter BITS = 5;

input clk, rst, valid, in;
input [BITS-1 : 0] pattern;
output reg out;

reg [BITS-1 : 0] buffer;
integer count;

always @ (posedge clk) begin
	if (rst == 1) begin
		buffer = 0;
		out = 0;
		count = 0;
	end
	else begin
		if (valid == 1) begin
			buffer = {buffer[BITS-2 : 0], in};
			count = count + 1;
			if (count == BITS) begin
				if (buffer == pattern) begin
					out = 1;
					// ** NON-OVERLAPPING **
					count = 0;
					// ** OVERLAPPING **
					//count = count -1;
				end
				else begin
					out = 0;
					count = count - 1;
				end
			end
			else out = 0;
		end
		else out = 0;
	end
end

endmodule
