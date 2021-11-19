module InvMixColumns(
	input wire [127:0] value,
	input wire clk,enable,reset,
	output reg [127:0] outValue,
	output reg success);


	function [7:0] MultiplyByTwo;
	input [7:0] x;
	begin
		if(x[7] == 1) MultiplyByTwo = ((x << 1) ^ 8'h1b);
			else MultiplyByTwo = x << 1;
		end
	endfunction

	integer i;
	always@(negedge clk) begin
	if(reset) begin
		outValue <= 128'h00000000000000000000000000000000;
		i<= 0;
		success <= 0;
	end
	else if(enable) begin
	for(i=0;i<=3;i=i+1) begin
	outValue[i*32+:8] <= MultiplyByTwo(MultiplyByTwo(MultiplyByTwo(value[(i*32)+:8]) ^ value[(i*32)+:8]) ^ value[(i*32)+:8]) ^ (MultiplyByTwo(MultiplyByTwo(MultiplyByTwo(value[(i*32 + 8)+:8]))) ^ value[(i*32 + 8)+:8]) ^ (MultiplyByTwo(MultiplyByTwo(MultiplyByTwo(value[(i*32 + 16)+:8]) ^ value[(i*32 + 16)+:8])) ^ value[(i*32 + 16)+:8]) ^ (MultiplyByTwo(MultiplyByTwo(MultiplyByTwo(value[(i*32 + 24)+:8])) ^ value[(i*32 + 24)+:8]) ^ value[(i*32 + 24)+:8]);
	outValue[(i*32 + 8)+:8] <= (MultiplyByTwo(MultiplyByTwo(MultiplyByTwo(value[(i*32)+:8])) ^ value[(i*32)+:8]) ^ value[(i*32)+:8]) ^ MultiplyByTwo(MultiplyByTwo(MultiplyByTwo(value[(i*32 + 8)+:8]) ^ value[(i*32 + 8)+:8]) ^ value[(i*32 + 8)+:8]) ^ (MultiplyByTwo(MultiplyByTwo(MultiplyByTwo(value[(i*32 + 16)+:8]))) ^ value[(i*32 + 16)+:8]) ^ (MultiplyByTwo(MultiplyByTwo(MultiplyByTwo(value[(i*32 + 24)+:8]) ^ value[(i*32 + 24)+:8])) ^ value[(i*32 + 24)+:8]);
	outValue[(i*32 + 16)+:8] <= (MultiplyByTwo(MultiplyByTwo(MultiplyByTwo(value[(i*32)+:8]) ^ value[(i*32)+:8])) ^ value[(i*32)+:8]) ^ (MultiplyByTwo(MultiplyByTwo(MultiplyByTwo(value[(i*32 + 8)+:8])) ^ value[(i*32 + 8)+:8]) ^ value[(i*32 + 8)+:8]) ^ MultiplyByTwo(MultiplyByTwo(MultiplyByTwo(value[(i*32 + 16)+:8]) ^ value[(i*32 + 16)+:8]) ^ value[(i*32 + 16)+:8]) ^ (MultiplyByTwo(MultiplyByTwo(MultiplyByTwo(value[(i*32 + 24)+:8]))) ^ value[(i*32 + 24)+:8]);
	outValue[(i*32 + 24)+:8] <= (MultiplyByTwo(MultiplyByTwo(MultiplyByTwo(value[(i*32)+:8]))) ^ value[(i*32)+:8]) ^ (MultiplyByTwo(MultiplyByTwo(MultiplyByTwo(value[(i*32 + 8)+:8]) ^ value[(i*32 + 8)+:8])) ^ value[(i*32 + 8)+:8]) ^ (MultiplyByTwo(MultiplyByTwo(MultiplyByTwo(value[(i*32 + 16)+:8])) ^ value[(i*32 + 16)+:8]) ^ value[(i*32 + 16)+:8]) ^ MultiplyByTwo(MultiplyByTwo(MultiplyByTwo(value[(i*32 + 24)+:8]) ^ value[(i*32 + 24)+:8]) ^ value[(i*32 + 24)+:8]);
	end
		
	success <= 1;
	end else success <= 0;
end //End always
endmodule	



