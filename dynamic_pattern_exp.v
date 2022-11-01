// Explicit moore fsm style coding for 3 bit dynamic pattern detector
module dyn_pattern_exp(clk, rst, valid, in, out);

parameter S0 = 4'b0000, // Reset state
		  S1 = 4'b0001, // 1st bit detected
		  S2 = 4'b0010, // 2nd bit detected
		  S3 = 4'b0011; // 3rd bit detected

input clk, rst, valid, in;
output reg out;

// Pattern stores the 3 bit pattern to detect
// While buffer is used to collect incoming input bits 
reg [2 : 0] pattern, buffer;
reg [1 : 0] cs, ns;

initial begin 
	pattern = 3'b010;
	buffer = 0;
	out = 0;
end

always @ (cs) begin
	case(cs)
		S0: out = 0;
		S1: out = 0;
		S2: out = 0;
		S3: out = 1;
		default: out = 0;
	endcase
end

always @ (posedge clk) begin
	if (rst == 1) cs <= S0;
	else if (valid == 1) begin
		buffer = {buffer[1:0],in};
		cs <= ns;
	end
	else cs <= cs;
end

always @ (cs, in) begin
	case(cs)
		S0: begin
			if (buffer[0] == pattern[2]) ns = S1;
			else ns = S0;
		end

		S1: begin
			if (buffer[1:0] == pattern[2:1]) ns = S2;
			else if (buffer[0] == pattern[2]) ns = S1;
			else ns = S0;
		end

		S2: begin
			if (buffer[2:0] == pattern[2:0]) ns = S3;
			else if (buffer[1:0] == pattern[2:1]) ns = S2;
			else if (buffer[0] == pattern[2]) ns = S1;
			else ns = S0;
		end

		S3: begin
			// For non-overlapping
			ns = S0;
			// For overlapping
			/*if (buffer[2:0] == pattern[2:0]) ns = S3;
			else if (buffer[1:0] == pattern[2:1]) ns = S2;
			else if (buffer[0] == pattern[2]) ns = S1;
			else ns = S0;*/
		end

		default: begin
			ns = S0;
		end
	endcase
end

endmodule
