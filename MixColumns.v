module MixColumns(
	input wire[127:0] value,
	input clk,enableMixColumn,reset,
	output reg[127:0] valueOut,
	output reg success);
	
function [7:0] TwoMultiplied;
	input [7:0] i;
	begin
		if(i[7] == 1) TwoMultiplied = ((i << 1) ^ 8'h1b);
		else TwoMultiplied = i << 1;
	end
endfunction

function [7:0] ThreeMultiplied;
	input [7:0] i;
	begin 
			
			ThreeMultiplied = TwoMultiplied(i) ^ i;
	end 
endfunction

integer j; 
	always@(negedge clk) 
begin
	if (reset)
	begin
		valueOut<=128'h00000000000000000000000000000000;
		j<= 0;
		success <= 0;
	end 
	else if (enableMixColumn)
	begin 
			for(j=0;j<=3;j=j+1)
			begin 
		valueOut[j*32+:8]  <= TwoMultiplied(value[(j*32)+:8])^(value[(j*32 + 8)+:8])^(value[(j*32 + 16)+:8])^ThreeMultiplied(value[(j*32 + 24)+:8]);
		valueOut[(j*32 + 8)+:8] <= ThreeMultiplied(value[(j*32)+:8])^TwoMultiplied(value[(j*32 + 8)+:8])^(value[(j*32 + 16)+:8])^(value[(j*32 + 24)+:8]);				valueOut[(j*32 + 16)+:8] <= (value[(j*32)+:8])^ThreeMultiplied(value[(j*32 + 8)+:8])^TwoMultiplied(value[(j*32 + 16)+:8])^(value[(j*32 + 24)+:8]);
		valueOut[(j*32 + 24)+:8]  <= (value[(j*32)+:8])^(value[(j*32 + 8)+:8])^ThreeMultiplied(value[(j*32 + 16)+:8])^TwoMultiplied(value[(j*32 + 24)+:8]);
			end 
			
			success <= 1;
			end else success <= 0;
end
endmodule
